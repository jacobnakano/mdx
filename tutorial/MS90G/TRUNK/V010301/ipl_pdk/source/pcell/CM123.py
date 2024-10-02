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
		InstanceArray,
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

class cm123(DloGen):   
	layerMapping = dict(  	m1        = ( "M1",      "drawing"),
				m2          = ( "M2",      "drawing"),
				m3          = ( "M3",      "drawing")
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

			specs("l", "40u")
			specs("nrows", "1")
			specs("ncolumns", "1")
			specs("dummy_l", False)
			specs("dummy_r", False)
			specs("dummy_t", False)
			specs("dummy_b", False)


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
			self.lval=params["l"]
			self.nrows = int(params["nrows"])
			self.ncolumns = int(params["ncolumns"])
			self.dummy_r = params["dummy_r"]
			self.dummy_l = params["dummy_l"]
			self.dummy_t = params["dummy_t"]
			self.dummy_b = params["dummy_b"]



			self.cellName = self.getName().rsplit("/")[1] 
			# Convert to process layer names
			self.layer      = LayerDict( self.tech, self.layerMapping)

			# Final parameter checking
			self.maskgrid = self.tech.getGridResolution()
			self.grid     = Grid( self.maskgrid, snapType=SnapType.CEIL)
			self.resolution = self.tech.dbu2uu(1) * 5

	# Note that all values are first snapped to the closest grid points.
			self.l = self.grid.snap( self.l)
	# Process specific parameters
	def genLayout (self): 
			fl = self.l
			nrows = self.nrows
			ncolumns = self.ncolumns
			dummy_l = self.dummy_l
			dummy_r = self.dummy_r
			dummy_t = self.dummy_t
			dummy_b = self.dummy_b
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
			
			originX = 0.0
			originY = 0.0






			pw = 1.0
			px = 0.8
			py = 0.75
			#
			# set mosaic delta
			#
			dx = 36.83
			dy = fl+4.5
			#
			# place device
			#
			InstArrId=InstanceArray("MIM13_W30", dX=dx,dY=dy,numRows=nrows,numCols=ncolumns,params=ParamArray(l=self.lval))
			InstArrId.setOrigin( Point(0.0,0.0))
		
			#
			# place dummy device
			#
			if  dummy_l :
				llx = originX - dx
				lly = originY
				InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=nrows,numCols=1,params=ParamArray(l=self.lval))
				InstArrId.setOrigin( Point(llx,lly))
				
			#
			# place dummy device
			#
			if  dummy_r :
				llx = originX + dx * ncolumns
				lly = originY
				InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=nrows,numCols=1,params=ParamArray(l=self.lval))
				InstArrId.setOrigin( Point(llx,lly))
				
					
					
			#
			# place dummy device
			#
			if  dummy_t :
				llx = originX 
				lly = originY + dy * nrows
				InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=1,numCols=ncolumns,params=ParamArray(l=self.lval))
				InstArrId.setOrigin( Point(llx,lly))
				if dummy_l :
					llx = originX - dx
					InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=1,numCols=1,params=ParamArray(l=self.lval))
					InstArrId.setOrigin( Point(llx,lly))
				if dummy_r:	
					llx = originX + dx * ncolumns
					InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=1,numCols=1,params=ParamArray(l=self.lval))
					InstArrId.setOrigin( Point(llx,lly))
				
			if  dummy_b :
				llx = originX 
				lly = originY -dy
				InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=1,numCols=ncolumns,params=ParamArray(l=self.lval))
				InstArrId.setOrigin( Point(llx,lly))
				if dummy_l :
					llx = originX - dx
					InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=1,numCols=1,params=ParamArray(l=self.lval))
					InstArrId.setOrigin( Point(llx,lly))
				if dummy_r:	
					llx = originX + dx * ncolumns
					InstArrId=InstanceArray("MIM13_W30D", dX=dx,dY=dy,numRows=1,numCols=1,params=ParamArray(l=self.lval))
					InstArrId.setOrigin( Point(llx,lly))

	
			#
			# create plus M2/M3
			#
			llx = originX
			if dummy_l :
				llx = llx-dx
			urx = originX+dx*ncolumns
			if dummy_r :
				urx = urx+dx
	
			ury = originY+dy
			if dummy_b :
				ury = ury-dy
			ury = ury-py
			lly = ury-pw
			shapeId = Rect(self.layer.m2,Box(llx,lly,urx,ury))
			self.plusPinId.addShape(shapeId)
			
			
			if dummy_b :
				rangeStart = 1
			else :
				rangeStart = 2
			if dummy_t :
				rangeStop = nrows+2
			else:
				rangeStop = nrows+1
				
			for i in range(rangeStart,rangeStop):
				ury = ury+dy
				lly = ury-pw
				shapeId = Rect(self.layer.m2,Box(llx,lly,urx,ury))
				self.plusPinId.addShape(shapeId)
			urx = originX+dx
			if dummy_l :
				urx = urx-dx
			urx = urx-px
			llx = urx-pw
	
			lly = originY
			if dummy_b :
				#ly = lly-dy
				lly = lly-dy
			ury = originY+dy*nrows
			if dummy_t :
				ury = ury+dy
			if dummy_l:
				rangeStart = 0
			else :
				rangeStart = 1
			if dummy_r:
				rangeStop = ncolumns + 2
			else:
				rangeStop = ncolumns + 1
				
					
			for i in range(rangeStart, rangeStop):
				shapeId = Rect(self.layer.m3,Box(llx,lly,urx,ury))
				self.plusPinId.addShape(shapeId)
				urx = urx+dx
				llx = urx-pw
					
			#
			# create minus M2/M3
			#
			llx = originX
			if dummy_l:
				llx = llx-dx
			urx = originX+dx*ncolumns
			if dummy_r:
				urx = urx+dx
	
			lly = originY
			if dummy_b:
				lly = lly-dy
			lly = lly+py
			ury = lly+pw
			shapeId = Rect(self.layer.m2,Box(llx,lly,urx,ury))
			self.minusPinId.addShape(shapeId)
			
			if dummy_b:
				rangeStart =1
			else:
				rangeStart =2
			if dummy_t:
				rangeStop=nrows+2
			else:
				rangeStop=nrows+1
					
			for i in range(rangeStart,rangeStop):
				lly = lly+dy
				ury = lly+pw
				shapeId = Rect(self.layer.m2,Box(llx,lly,urx,ury))
				self.minusPinId.addShape(shapeId)
				
	
			llx = originX
			if dummy_l:
				llx = llx-dx
			llx = llx+px
			urx = llx+pw
	
			lly = originY
			if dummy_b:
				lly = lly-dy
			ury = originY+dy*nrows
			if dummy_t:
				ury = ury+dy
			if dummy_l:
				rangeStart = 0
			else:
				rangeStart = 1
			if dummy_r:
				rangeStop = ncolumns +2
			else:
				rangeStop = ncolumns +1
					
			for i in range(rangeStart,rangeStop):
				shapeId = Rect(self.layer.m3,Box(llx,lly,urx,ury))
				self.minusPinId.addShape(shapeId)
				llx = llx+dx
				urx = llx+pw
			
		
			
			
			
			
			
			
			
			
