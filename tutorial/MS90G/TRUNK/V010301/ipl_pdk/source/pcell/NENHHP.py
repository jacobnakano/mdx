import copy
import traceback
import math

from cni.dlo import (
		Box,
		ChoiceConstraint,
		DeviceContext,
		Direction,
		DloGen,
		FailAction,
		GapStyle,
		Grid,
		Grouping,
		Instance,
		Layer,
		LayerMaterial,
		Location,
		Net,
		Orientation,
		ParamArray,
		ParamSpecArray,
		Pin,
		Point,
		Polygon,
		Path,
		RangeConstraint,
		Rect,
		Ruleset,
		Shape,
		ShapeFilter,
		SnapType,
		StepConstraint,
		Term,
		TermType,
		Text,
		Unique,
		NameMapper,     
)

import re
import cni

cni.utils.importConstants(Direction)
from cni.integ.common import (
		stretchHandle,
		autoAbutment,
)


from MosUtils import (
		orderedRuleset,
		rulesmgr,
		LayerDict,
		Pattern,
		RulesDict,
)

from cdfutil import (
		cdfNumeric,
)
from PcellSupport import (
		celResizeRectUnsymmetric2,
		celResizeRectUnsymmetric4,
		celCreateRingLayer,
		celAreaCorrect,
		celCreateStandard, 
		convertType,
)

class nenhhp(DloGen):   
	layerMapping = dict(	poly          = ( "PO",      "drawing"),
				nd            = ( "ND",      "drawing"),
				metal1        = ( "M1",      "drawing"),
				cont          = ( "CT",      "drawing"),
				ni            = ( "NI",      "drawing"),
				#hvpw          = ( "HVPW",    "drawing"),
				#hv33          = ( "HV33",    "drawing"),
				nch           = ( "NCH",    "drawing"),
				pwlvs         = ( "PWLVS",    "drawing"),
		)

		
		###########################################################
		
	@classmethod
	def defineParamSpecs( cls, specs):
			"""Define the PyCell parameters.  The order of invocation of
			specs() becomes the order on the form.
			
			Arguments:
			specs - (ParamSpecArray)  PyCell parameters
						"""

			maskgrid   = specs.tech.getGridResolution()
			#resolution = specs.tech.uu2dbu(1) * 100

			specs("l", "100n")
			specs("wpf", "220n")
			specs("fingers", "1")
			specs("shared_sd", "Drain")
			specs("dummy_l", "0")
			specs("dummy_r", "0")
			specs("abut_l", False)              
			specs("abut_r", False)              
			specs("stretch_l", 0.28)
			specs("stretch_r", 0.28)
			specs("contact_l", True)           
			specs("contact_r", True)           


	def setupParams(self, params):
			"""Process PyCell parameters, prior to geometric construction.
			Decisions about process rules and PyCell-specific behaviors
			should be confined to this method.
			
			Create most useful format for variables to be used in later
			methods.

			Arguments:
			params - (ParamArray)  PyCell parameters
				"""
		
			# Convert any scaled number parameter values from string to the
			# corresponding floating point number values. Note that all float
			# values are assumed to be in units of microns, so that the 
			# scaled number "500n" gets converted to 0.5 (versus 0.5e-06).

			self.l = cdfNumeric(params["l"]) * 1e6
			self.wpf = cdfNumeric(params["wpf"]) * 1e6
			self.fingers = int(params["fingers"])
			self.shared_sd = params["shared_sd"]
			self.dummy_l = int(params["dummy_l"])
			self.dummy_r = int(params["dummy_r"])
			self.abut_l = params["abut_l"]                          
			self.abut_r = params["abut_r"]                          
			self.stretch_l = cdfNumeric(params["stretch_l"])
			self.stretch_r = cdfNumeric(params["stretch_r"])
			self.contact_l = params["contact_l"]                            
			self.contact_r = params["contact_r"]                            

			self.cellName = self.getName().rsplit("/")[1] 
			# Convert to process layer names
			self.layer      = LayerDict( self.tech, self.layerMapping)

			# Final parameter checking
			self.maskgrid = self.tech.getGridResolution()
			self.grid     = Grid( self.maskgrid, snapType=SnapType.CEIL)
			self.resolution = self.tech.dbu2uu(1) * 5

	# Note that all values are first snapped to the closest grid points.
			self.wpf = self.grid.snap( self.wpf)
			self.l = self.grid.snap( self.l)
	# Process specific parameters
	def genLayout (self):               
		ND_s            = 0.14
		ND_cs1          = 0.22
		ND_em3          = 0.45
		PO_o2           = 0.16
		NI_el           = 0.22
		NI_ek           = 0.13
		PI_ep           = 0.02
		#HV33_en1        = 0.62
		NCH_en          = 0.22
		NCH_em          = 0.07
		CT_wh           = 0.12
		CT_s            = 0.14
		CT_cw           = 0.11
		CT_eg2          = 0.05
		M1_sv           = 0.17
		M1_eh           = 0.05

		length = self.l
		width = self.wpf
		fingers = self.fingers
		abut_l = self.abut_l
		abut_r = self.abut_r
		dummy_l = self.dummy_l
		dummy_r = self.dummy_r
		contact_l = self.contact_l
		contact_r = self.contact_r
		stretch_l = self.stretch_l
		stretch_r = self.stretch_r
		shared_sd = self.shared_sd
		resolution = self.maskgrid  
		
		if abut_l:
			dummy_l = 0
		if abut_r:
			dummy_r = 0

		sourceTerm    = "S"
		drainTerm     = "D"
		gateTerm      = "G"
		bulkTerm      = "B"

		self.sourceTermId    = Term( sourceTerm , TermType.INPUT_OUTPUT)
		#self.sourcePinId     = Pin ( sourceTerm , sourceTerm)
			
		self.drainTermId     = Term( drainTerm, TermType.INPUT_OUTPUT)
		#self.drainPinId      = Pin ( drainTerm, drainTerm)
			
		self.gateTermId      = Term( gateTerm, TermType.INPUT_OUTPUT)
		self.gatePinId       = Pin ( gateTerm, gateTerm) 

		self.bulkTermId      = Term( bulkTerm, TermType.INPUT_OUTPUT)
		self.bulkPinId       = Pin ( bulkTerm, bulkTerm)    

		gateTermGrp = Grouping("gate") 
		rightTerm = Grouping("rightTerm")
		leftTerm = Grouping("leftTerm")
			
		drainTermGrp = Grouping("drainTermGrp")
		sourceTermGrp = Grouping("sourceTermGrp")
		
		cellName = self.cellName        
		#print "contact_l" , contact_l
		# Set Pcell origin and body coordinates
		ptOriginX = 0.0
		ptOriginY = 0.0
			
		llx = ptOriginX
		urx = ptOriginX + length
		lly = ptOriginY - PO_o2
		ury = ptOriginY + width + M1_sv
		ury2 = ptOriginY + width 
		ury3 = ptOriginY 
		
		#id fingers > 1 we strap the gate

		strap_gate = 0
		if fingers > 1 :
			strapTopGatePin = Pin("G_1", "G")
			strap_gate = 1
		else:
			strapTopGatePin = Pin("G_1T", "G")
			strapBotGatePin = Pin("G_1B", "G")

		for i in (range (0, self.fingers)):
			polyUpperBbox = Box(llx,ury2,urx,ury)
			polyUpperRect = Rect(self.layer.poly,polyUpperBbox)
			polyLowerBbox = Box(llx,lly,urx ,ury3 )
			polyLowerRect = Rect(self.layer.poly,polyLowerBbox)
			polyMiddleBbox = Box(llx,ury3,urx,ury2)
			polyMiddleRect = Rect(self.layer.poly,polyMiddleBbox)
			lastGate_urx = urx
			if strap_gate < 1 :
				strapTopGatePin.addShape(polyUpperRect)
				strapBotGatePin.addShape(polyLowerRect)
			llx = llx + length + CT_wh + CT_cw * 2 
			urx = llx + length


		if fingers > 1 :
			urx = llx  - (  CT_wh + CT_cw * 2 )
			llx = ptOriginX
			lly = ury 
			ury = ury + (CT_wh+M1_eh*2)
			polyUpperStrap = Box(llx,lly,urx,ury)
			polyUpperSTrapRect = Rect(self.layer.poly,polyUpperStrap)
			strapTopGatePin.addShape(polyUpperSTrapRect)
			
		# Add dummy poly gates  L
		urx = ptOriginX - (CT_wh+CT_cw*2)
		llx = urx - length
		lly = ptOriginY - PO_o2
		ury = ptOriginY + width + M1_sv

		for i in (range (0, dummy_l)):
			
			dummyPolyL = Box(llx,lly,urx,ury)
			dummyPolyLRect = Rect(self.layer.poly,dummyPolyL)
			urx = urx -( length + CT_wh + CT_cw * 2 )
			llx = llx - ( length + CT_wh + CT_cw * 2 )

		# Add Dummy Poly gates R
		urx = lastGate_urx + (CT_wh+CT_cw*2) + length
		llx = urx - length
		lly = ptOriginY - PO_o2
		ury = ptOriginY + width + M1_sv

		for i in (range (0, dummy_r)):
			dummyPolyL = Box(llx,lly,urx,ury)
			dummyPolyLRect = Rect(self.layer.poly,dummyPolyL)
			urx = urx +( length + CT_wh + CT_cw * 2 )
			llx = llx + ( length + CT_wh + CT_cw * 2 )


		# create the diffusion
		if abut_l :
			llx = ptOriginX - max(stretch_l , 0.0 )
		elif dummy_l :
			llx =  ptOriginX - dummy_l * ( length + CT_wh + CT_cw * 2 ) - (CT_wh+CT_cw+CT_eg2)
		else :
			llx =  ptOriginX  - (CT_wh+CT_cw+CT_eg2)          

		if abut_r :
			urx = lastGate_urx + max(stretch_r , 0.0 )
		elif dummy_r :
			urx =  lastGate_urx + dummy_r * ( length + CT_wh + CT_cw * 2 ) + (CT_wh+CT_cw+CT_eg2)
		else :
			urx =  lastGate_urx  + (CT_wh+CT_cw+CT_eg2) 

		lly = 0.0;
		ury = width;
		mainDiff = Box(llx,lly,urx,ury)
		
		mainDiffRect = Rect(self.layer.nd,mainDiff)
	

		# Create left ND for Auto Abutment
		if abut_l :
			if stretch_l > 0.0 :
				llx = ptOriginX - stretch_l
				urx = ptOriginX
			else :
				llx = ptOriginX
				urx = ptOriginX - stretch_l
		elif dummy_l :
				urx = ptOriginX
				llx = urx - (CT_wh+CT_cw*2)
		else:
				urx = ptOriginX
				llx = urx - (CT_wh+CT_cw+CT_eg2)
	
		leftDiffBox = Box(llx,lly,urx,ury)
		leftDiffRect = Rect(self.layer.nd, leftDiffBox)
	
		# Create Rt ND for Auto Abutment
		# Create left ND for Auto Abutment
	
		if abut_r :
			if stretch_r > 0.0 :
				urx = lastGate_urx + stretch_r
				llx = lastGate_urx
			else :
				urx = lastGate_urx
				llx = lastGate_urx + stretch_r
		elif dummy_r :
				llx = lastGate_urx
				urx = llx + (CT_wh+CT_cw*2)
		else:
				llx = lastGate_urx
				urx =  llx + (CT_wh+CT_cw+CT_eg2)
	
		rightDiffBox = Box(llx,lly,urx,ury)
		rightDiffRect = Rect(self.layer.nd, rightDiffBox)
		
		# Calculate contact enclose using min spacing.
		num_ctx = math.floor( ((width - 2 * CT_eg2 + CT_s) / ( CT_wh + CT_s)) + 1e-18)
		ct_coverage = num_ctx * CT_wh + (num_ctx - 1 ) * CT_s
		#print "ct_cverage" , ct_coverage , "num_ctx ", num_ctx
		ct_offset = self.grid.snap( (width - ct_coverage) * 0.5 )
		ct_offset2 = width - ct_coverage - ct_offset
		# Create dummy M1 Left
		baseGateX = ptOriginX - (CT_wh+CT_cw*2) - length
		#lly = ptOriginY + CT_eg2 - M1_eh
		# ury = ptOriginY + width - ( CT_eg2 - M1_eh )
		lly = ptOriginY + ct_offset2 - M1_eh
		ury =  ptOriginY + ct_offset2 - M1_eh + ct_coverage + 2 * M1_eh
	
		for i in (range (0, dummy_l)):
			llx = baseGateX - CT_wh - CT_cw - M1_eh
			urx = llx +(CT_wh+M1_eh*2)
			dummyL_M1_Box  = Box(llx,lly,urx,ury)
			dummyL_M1_Rect = Rect(self.layer.metal1, dummyL_M1_Box)
			contBox = Box(llx + M1_eh,lly + M1_eh , urx - M1_eh, ury - M1_eh)
			dummyL_M1_Rect.fillBBoxWithRects( self.layer.cont,
							  contBox, 
							  width = CT_wh, 
							  height = CT_wh, 
							  spaceX = CT_s, 
							  spaceY = CT_s, 
							  gapStyle=GapStyle.DISTRIBUTE)
			baseGateX = baseGateX - (CT_wh+CT_cw*2) - length
	
	
		#  Create dummy M1 Right
		baseGateX = lastGate_urx + (CT_wh+CT_cw*2) + length
	
		#lly = ptOriginY + CT_eg2 - M1_eh
		#ury = ptOriginY + width - ( CT_eg2 - M1_eh )
		lly = ptOriginY + ct_offset2 - M1_eh
		ury =  ptOriginY + ct_offset2 - M1_eh + ct_coverage + 2 * M1_eh
		for i in (range (0, dummy_r)):
			llx = baseGateX + CT_cw - M1_eh
			urx = llx +(CT_wh+M1_eh*2)
			dummyL_M1_Box  = Box(llx,lly,urx,ury)
			dummyL_M1_Rect = Rect(self.layer.metal1, dummyL_M1_Box)
			contBox = Box(llx + M1_eh,lly + M1_eh , urx - M1_eh, ury - M1_eh)
			dummyL_M1_Rect.fillBBoxWithRects( self.layer.cont,
							  contBox, 
							  width = CT_wh, 
							  height = CT_wh, 
							  spaceX = CT_s, 
							  spaceY = CT_s, 
							  gapStyle=GapStyle.DISTRIBUTE)
			baseGateX = baseGateX + (CT_wh+CT_cw*2) + length

			
		SD_Term = []
		# Create source / drain pins
		#print "L=" , contact_l, "R=" , contact_r
		if shared_sd == "Drain" :
			#print "shared SRC"
			SD_Term.append("S")
			SD_Term.append("D")
			if not contact_l :
				#leftDiffTerm = Term("S_1", TermType.INPUT_OUTPUT)
				#leftDiffTerm.setMustJoin(self.sourceTermId)
				#print "CT L FALSE"
				leftDiffPin = Pin("S","S")
				leftDiffPin.addShape(leftDiffRect)
				
			if not contact_r :
				#print "CTR FALSE"
				if fingers == 1 :
					#print "FING 1"
					rightDiffPin = Pin("D","D")
					rightDiffPin.addShape(rightDiffRect)
				else :
					if fingers % 2 == 0 :
						rightDiffTerm = Term("S_%d" % (int(fingers/2)+1), TermType.INPUT_OUTPUT)
						rightDiffTerm.setMustJoin(self.sourceTermId)					
						rightDiffPin = Pin("S_%d" % (int(fingers/2) +1),"S_%d" % (int(fingers/2)+1))
						rightDiffPin.addShape(rightDiffRect)
					else:
						rightDiffTerm = Term("D_%d" % (int(fingers/2)+1), TermType.INPUT_OUTPUT)
						rightDiffTerm.setMustJoin(self.drainTermId)					
						rightDiffPin = Pin("D_%d" % (int(fingers/2) +1),"D_%d" % (int(fingers/2)+1))
						rightDiffPin.addShape(rightDiffRect)
				
			
		else :
			#print "SHARD DRAIN"
			SD_Term.append("D")
			SD_Term.append("S")
			if  not contact_l  :
				#print "CTL FALSE"
				#print "LOOP 1"
				#leftDiffTerm = Term("D_1", TermType.INPUT_OUTPUT)
				#leftDiffTerm.setMustJoin(self.drainTermId)
				leftDiffPin = Pin("D","D")
				leftDiffPin.addShape(leftDiffRect)
				
			if not contact_r  :
				#print "CTR FALSE"
				if fingers == 1 :
					#print "FING 1"
					rightDiffPin = Pin("S","S")
					rightDiffPin.addShape(rightDiffRect)
				else:
					if fingers % 2 == 0 :
						#print  "LOOP 2"
						rightDiffTerm = Term("D_%d" % (int(fingers/2)+1) ,TermType.INPUT_OUTPUT)
						rightDiffTerm.setMustJoin(self.drainTermId)
						rightDiffPin = Pin("D_%d" % (int(fingers/2)+1 ),"D_%d" % (int(fingers/2)+1))
						rightDiffPin.addShape(rightDiffRect)
					else:
						rightDiffTerm = Term("S_%d" % (int(fingers/2)+1), TermType.INPUT_OUTPUT)
						rightDiffTerm.setMustJoin(self.sourceTermId)
						rightDiffPin = Pin("S_%d" % (int(fingers/2)+1) ,"S_%d" % (int(fingers/2)+1))
						rightDiffPin.addShape(rightDiffRect)
												
												
#		autoAbutment(
#				shape = leftDiffRect,
#				pinSize = self.wpf,
#				directions = [ WEST ],
#				abutClass = "PENHT33",
#				abut2PinEqual   = [ { "spacing":0.0}, { "leftShape":"same"    }, { "leftShape":"same"    } ],
#				abut2PinBigger  = [ { "spacing":0.0}, { "leftShape":"large"   }, { "leftShape":"large"   } ],
#				abut3PinBigger  = [ { "spacing":0.0}, { "leftShape":"largeExt"}, { "leftShape":"largeExt"} ],
#				abut3PinEqual   = [ { "spacing":0.0}, { "leftShape":"largeExt"}, { "leftShape":"sameExt" } ],
#				abut2PinSmaller = [ { "spacing":0.0}, { "leftShape":"small"   }, { "leftShape":"small"   } ],
#				abut3PinSmaller = [ { "spacing":0.0}, { "leftShape":"small"   }, { "leftShape":"small" } ],
#				function = "MS90G_abutFunction",
#				noAbut = [ { "spacing":PD_s}],
#			)
		leftDiffRect.props["name"] = "left"
		leftDiffRect.props["abutClass"] = "NENHHP"
		leftDiffRect.props["abutAccessDir"] = "(\"left\")"
		leftDiffRect.props["abutDir"] = int(4)
		leftDiffRect.props["abutFunction"] = "MS90G_abutFunction"
		leftDiffRect.props["abutGateNet"] = "G"
		leftDiffRect.props["vxlInstSpacingDir"] = "(\"left\")"
		leftDiffRect.props["vxlInstSpacingRule"] = ND_s
		
		rightDiffRect.props["name"] = "right"
		rightDiffRect.props["abutClass"] = "NENHHP"
		rightDiffRect.props["abutAccessDir"] = "(\"right\")"
		rightDiffRect.props["abutDir"] = int(8)
		rightDiffRect.props["abutFunction"] = "MS90G_abutFunction"
		rightDiffRect.props["abutGateNet"] = "G"
		rightDiffRect.props["vxlInstSpacingDir"] = "(\"right\")"
		rightDiffRect.props["vxlInstSpacingRule"] = ND_s
		
#		autoAbutment(
#				shape = rightDiffRect,
#				abutDirection = "right",
#				abutClass = "PENHT33",
#				abutFunction = "MS90G_abutFunction",
#				spacingRule = PD_s
#		
					
					
					
		baseGateX = 0.0
		for i in range (0, (fingers+1)):
			#print "i = " , i , "L=" , contact_l, "R=" , contact_r
			if ( i == 0 and contact_l  ) or ( i == fingers  and contact_r ) or  ( i > 0 and i < fingers ) :
				#print "Inner loop"
				llx = baseGateX - CT_wh - CT_cw - M1_eh
				urx = llx +(CT_wh+M1_eh*2)
				SD_M1_Box  = Box(llx,lly,urx,ury)
				SD_M1_Rect = Rect(self.layer.metal1, SD_M1_Box)
				if ( i < 2 ) :
					termName = SD_Term[i%2] 
				else :
					termName = "%s_%d" % (SD_Term[i%2] , int(i/2)+1)
					#print "termName str is %s" % termName
					SDMetTerm = Term( termName, TermType.INPUT_OUTPUT)
					if SD_Term[i%2] == "S" :
						SDMetTerm.setMustJoin(self.sourceTermId)
					else:
						SDMetTerm.setMustJoin(self.drainTermId)
						
				#print "MET termName is %s" % termName
				#SDMetTerm = Term( termName, TermType.INPUT_OUTPUT)
				
				SDMetPin = Pin(termName,termName)
				SDMetPin.addShape(SD_M1_Rect)
				if( i == 0 ):
					SDMetPin.addShape(leftDiffRect)
				if( i == fingers) :
					SDMetPin.addShape(rightDiffRect)
						
						
				contBox = Box(llx + M1_eh,lly + M1_eh , urx - M1_eh, ury - M1_eh)
				SD_M1_Rect.fillBBoxWithRects( self.layer.cont,  
							      contBox, 
							      width = CT_wh, 
							      height = CT_wh, 
							      spaceX = CT_s, 
							      spaceY = CT_s, 
							      gapStyle=GapStyle.DISTRIBUTE)
			
			baseGateX = baseGateX + length + CT_wh + 2 * CT_cw
	
		#  CREATE NI
		llx =     mainDiffRect.getLeft() - NI_ek
		urx =     mainDiffRect.getRight() + NI_ek
		lly =     mainDiffRect.getBottom() - max( NI_el, PO_o2+PI_ep)
		#if fingers > 1 :
		#	ury =  mainDiffRect.getTop()  + max(NI_el,((CT_wh+M1_eh*2)+M1_sv)+PI_ep)
		#else :
		#	ury =  mainDiffRect.getTop()  + max(NI_el, M1_sv+PI_ep)
		ury =  mainDiffRect.getTop()  + max(NI_el,((CT_wh+M1_eh*2)+M1_sv)+PI_ep)
	
		NI_Box  = Box(llx,lly,urx,ury)
		NI_Rect = Rect(self.layer.ni, NI_Box)
	
		##  Create HVPW 
		#llx =     mainDiffRect.getLeft() - ND_em3
		#urx =     mainDiffRect.getRight() + ND_em3
		#ury =     mainDiffRect.getTop() + ND_em3
		#lly =     mainDiffRect.getBottom() - ND_em3
		#HVPW_Box  = Box(llx,lly,urx,ury)
		#HVPW_Rect = Rect(self.layer.hvpw, HVPW_Box)
	        #self.bulkPinId.addShape(HVPW_Rect)
		##  Create HV33
		#llx =     mainDiffRect.getLeft() - HV33_en1
		#urx =     mainDiffRect.getRight() + HV33_en1
		#ury =     mainDiffRect.getTop() + HV33_en1
		#lly =     mainDiffRect.getBottom() - HV33_en1
		#HV33_Box  = Box(llx,lly,urx,ury)
		#HV33_Rect = Rect(self.layer.hv33, HV33_Box)

		#  Create PWLVS 
		llx =     mainDiffRect.getLeft() - ND_cs1
		urx =     mainDiffRect.getRight() + ND_cs1
		ury =     mainDiffRect.getTop() + ND_cs1
		lly =     mainDiffRect.getBottom() - ND_cs1
		PWLVS_Box  = Box(llx,lly,urx,ury)
		PWLVS_Rect = Rect(self.layer.pwlvs, PWLVS_Box)
	        self.bulkPinId.addShape(PWLVS_Rect)
		#  Create NCH 
		llx =     mainDiffRect.getLeft() - NCH_em
		urx =     mainDiffRect.getRight() + NCH_em
		ury =     mainDiffRect.getTop() + NCH_en
		lly =     mainDiffRect.getBottom() - NCH_en
		NCH_Box  = Box(llx,lly,urx,ury)
		NCH_Rect = Rect(self.layer.nch, NCH_Box)











