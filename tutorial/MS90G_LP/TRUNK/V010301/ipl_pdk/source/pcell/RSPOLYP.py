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

from PcellSupport import (
	celCreateRingLayer,
	celResizeRectUnsymmetric2,
	celResizeRectUnsymmetric4,
	LayerDict,
	convertScaledNumberString,
	convertType,
)


from cdfutil import (
		cdfNumeric,
)

class rspolyp(DloGen):   
	layerMapping = dict(    poly          = ( "PO",      "drawing"),
				pd            = ( "PD",      "drawing"),
				m1        = ( "M1",      "drawing"),
				cont          = ( "CT",      "drawing"),
				p1            = ( "PI",      "drawing"),
				sb            = ( "SB",      "drawing"),
				reslvs        = ( "RESLVS",    "drawing"),
				pppo        =   ( "PPPO",    "drawing")

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

			specs("l", "9.055u")
			specs("w", "2u")
			specs("fingers", "1")
			specs("dummy_l", "0")
			specs("dummy_r", "0")


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
			self.w = cdfNumeric(params["w"]) * 1e6
			self.fingers = int(params["fingers"])
			self.dummy_l = int(params["dummy_l"])
			self.dummy_r = int(params["dummy_r"])

			self.cellName = self.getName().rsplit("/")[1] 
			# Convert to process layer names
			self.layer      = LayerDict( self.tech, self.layerMapping)

			# Final parameter checking
			self.maskgrid = self.tech.getGridResolution()
			self.grid     = Grid( self.maskgrid, snapType=SnapType.CEIL)
			self.resolution = self.tech.dbu2uu(1) * 5

	# Note that all values are first snapped to the closest grid points.
			self.w = self.grid.snap( self.w)
			self.l = self.grid.snap( self.l)
	# Process specific parameters
	def genLayout (self): 
		PO_ss           = 0.25
		CT_wh           = 0.12
		CT_s            = 0.14
		M1_eh           = 0.05
		PPPO_en1        = 0.22
		PPPO_en3        = 0.2
		PPPO_em3        = 0.1
                PPPO_em2        = 0.32
                SB_o1           = 0.32
                SB_c            = 0.22

		length = self.l
		width = self.w
		fingers = self.fingers
		dummy_l = self.dummy_l
		dummy_r = self.dummy_r
		resolution = self.maskgrid  

		plusTerm    =   "PLUS"
		minusTerm     = "MINUS"

		self.plusTermId    = Term( plusTerm , TermType.INPUT_OUTPUT)
		self.plusPinId     = Pin ( plusTerm , plusTerm)

		self.minusTermId    = Term( minusTerm , TermType.INPUT_OUTPUT)
		self.minusPinId     = Pin ( minusTerm , minusTerm)

		cellName = self.cellName        
		# Set Pcell origin and body coordinates
		ptOriginX = 0.0
		ptOriginY = 0.0
			
		llx = ptOriginX
		urx = ptOriginX + width
		resBbox = []
		for i in  range ( 0 ,fingers ) :
			#
			# create RESLVS fingers
			#
			lly = ptOriginY
			ury = lly + length
			resLvsBbox = Box(llx,lly,urx,ury)
			resLvsRect = Rect(self.layer.reslvs,resLvsBbox)
			
			lly =  lly-(CT_wh+PPPO_en3+SB_c)
			ury =  ury+(CT_wh+PPPO_en3+SB_c)
			resPoBbox = Box(llx,lly,urx,ury)
			resPoRect = Rect(self.layer.poly,resPoBbox)
			resBbox.append(resPoBbox)
			llx = urx+PO_ss
			urx = llx+width
		#
		# Create dummy Left
		resbod_l = []
		if dummy_l > 0 :
			
			urx = resBbox[0].getLeft()  - PO_ss
			llx = urx-width

			lly = resBbox[0].getBottom()
			ury = resBbox[0].getTop()

			for  i in range(0 ,dummy_l):
				resdummylBbox = Box(llx,lly,urx,ury)
				resdummylRect = Rect(self.layer.poly,resdummylBbox)
				resbod_l.append(resdummylBbox)	
				urx = llx - PO_ss
				llx = urx-width

		#
		# Create dummy Right
		resbod_r = []
		if dummy_r > 0 :
			
			llx = resBbox[fingers -1].getRight()  + PO_ss
			urx = llx + width

			lly = resBbox[len(resBbox)-1].getBottom()
			ury = resBbox[len(resBbox)-1].getTop()

			for  i in range(0 ,dummy_r):
				resdummyrBbox = Box(llx,lly,urx,ury)
				#print llx , lly , urx , ury
				resdummyrRect = Rect(self.layer.poly,resdummyrBbox)
				resbod_r.append(resdummyrBbox)	
				llx = urx + PO_ss
				urx = llx + width
					
				


		tops = []
		bottoms = []
		num_ctx = math.floor( ((width - 2 * PPPO_en3 + CT_s + 1e-18) / ( CT_wh + CT_s)))
		ct_coverage = num_ctx * CT_wh + (num_ctx - 1 ) * CT_s
		#print "ct_cverage" , ct_coverage , "num_ctx ", num_ctx
		ct_enc = self.grid.snap(width -ct_coverage)
		ct_offset = self.grid.snap( (width - ct_coverage) * 0.5 )
		ct_offset2 = ct_enc - ct_offset
		
		#print "ct_enc", ct_enc , "ct_off" , ct_offset, "ct_off2" , ct_offset2
		for  i in range(0 ,fingers):
			for  j in range(0 ,2):
				#llx = resBbox[i].getLeft() +  PPPO_en3
				#urx = resBbox[i].getRight() - PPPO_en3
				llx = resBbox[i].getLeft() + ct_offset2 
				urx = resBbox[i].getRight() - ct_offset 
				if j == 0:
					lly = resBbox[i].getBottom() + PPPO_en3
				else :
					lly = resBbox[i].getTop()  - PPPO_en3 - CT_wh
				ury = lly + CT_wh
				
				#llx_M1 = llx - M1_eh
				#urx_M1 = urx + M1_eh
				llx_M1 = resBbox[i].getLeft() + ct_offset2 - M1_eh
				urx_M1 = resBbox[i].getRight() -ct_offset + M1_eh 

				lly_M1 = lly - M1_eh
				ury_M1 = lly_M1 + CT_wh + 2 * M1_eh
				#
				# create plus/minus M1
				#
				

				
	
				contBox = Box(llx,lly,urx,ury)
				M1Bbox= Box(llx_M1,lly_M1,urx_M1,ury_M1)
				M1Rect = Rect(self.layer.m1,M1Bbox)
				M1Rect.fillBBoxWithRects( self.layer.cont,
							  contBox, 
							  width = CT_wh, 
							  height = CT_wh, 
							  spaceX = CT_s, 
							  spaceY = CT_s, 
							  gapStyle=GapStyle.DISTRIBUTE)
				if j == 0:
					bottoms.append(M1Bbox)
				else:
					tops.append(M1Bbox)	
				
		#
		# create plus pin
		#
		if fingers > 1 :
			llx = tops[0].getLeft()
			urx = tops[fingers -1].getRight()
			lly = tops[0].getBottom()
			ury = tops[fingers -1].getTop()
			plusStrapBox = Box(llx,lly,urx,ury)
			plusStrapRect = Rect(self.layer.m1,plusStrapBox)
			self.plusPinId.addShape(plusStrapRect)
		else :
			llx = tops[0].getLeft()
			urx = tops[0].getRight()
			lly = tops[0].getBottom()
			ury = tops[0].getTop()
			plusStrapBox = Box(llx,lly,urx,ury)
			plusStrapRect = Rect(self.layer.m1,plusStrapBox)
			self.plusPinId.addShape(plusStrapRect)
		#
		# create Minus pin
		#
		if fingers > 1 :
			llx = bottoms[0].getLeft()
			urx = bottoms[fingers -1].getRight()
			lly = bottoms[0].getBottom()
			ury = bottoms[fingers -1].getTop()
			minusStrapBox = Box(llx,lly,urx,ury)
			minusStrapRect = Rect(self.layer.m1,minusStrapBox)
			self.minusPinId.addShape(minusStrapRect)
		else :
			lx = bottoms[0].getLeft()
			urx = bottoms[0].getRight()
			lly = bottoms[0].getBottom()
			ury = bottoms[0].getTop()
			minusStrapBox = Box(llx,lly,urx,ury)
			minusStrapRect = Rect(self.layer.m1,minusStrapBox)
			self.minusPinId.addShape(minusStrapRect)
		#
		# create SB
		#
		if len(resbod_l) > 0 :
			llx = resbod_l[len(resbod_l)-1].getLeft() - SB_o1
		else :
			llx = resBbox[0].getLeft() - SB_o1
		#
		if len(resbod_r) > 0 :
			urx = resbod_r[len(resbod_r)-1].getRight() + SB_o1
		else :
			urx = resBbox[len(resBbox)-1].getRight() + SB_o1
			
		lly = resBbox[0].getBottom() + CT_wh+PPPO_en3+SB_c
		ury = resBbox[0].getTop() - ( CT_wh+PPPO_en3+SB_c)
			
		SBBox = Box(llx,lly,urx,ury) 
		SBRect = Rect(self.layer.sb,SBBox)
		#
		# create PPPO
		#
		if len(resbod_l) > 0 :
			llx = resbod_l[len(resbod_l)-1].getLeft() - PPPO_em2
		else :
			llx = resBbox[0].getLeft() - PPPO_em2
		#
		if len(resbod_r) > 0 :
			urx = resbod_r[len(resbod_r)-1].getRight() + PPPO_em2
		else :
			urx = resBbox[len(resBbox)-1].getRight() + PPPO_em2
			
		lly = resBbox[0].getBottom() -  PPPO_em2
		ury = resBbox[0].getTop() + PPPO_em2
			
		PPPOBox = Box(llx,lly,urx,ury) 
		PPPORect = Rect(self.layer.pppo,PPPOBox)

		


