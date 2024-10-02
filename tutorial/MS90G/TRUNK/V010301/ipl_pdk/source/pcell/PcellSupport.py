########################################################################
#                                                                      #
# Packages                                                             #
#                                                                      #
########################################################################

from cni.dlo import (
    AbutContact,
    Bar,
    Box,
    CompoundComponent,
    Contact,
    DeviceContext,
    DeviceContextManager,
    Direction,
    GapStyle,
    DloGen,
    Grid,
    Grouping,
    Instance,
    Layer,
    LayerMaterial,
    Location,
    Orientation,
    ParamArray,
    Path,
    PhysicalComponent,
    Pin,
    Point,
    Rect,
    RouteTarget,
    Ruleset,
    RulesetManager,
    Shape,
    ShapeFilter,
    SnapType,
    Term,
    Unique,
    ulist,
)

from cdfutil import (
        cdfNumeric,
)

from cni.utils import (
    getMinExtensions
)

from cni.integ.common import (
    Compare,
    Dictionary,
    isEven,
    isOdd,
    renameParams,
)

from _PyxDloApi import makeLineOfRects

import copy
import math
import time

SCRATCHPAD = ( -5, -5)

###############################################################################
"""
def celAreaCorrect (coord, minArea, grid, flag):
	if flag == "ew" :
	
		offsetImp = grid.snap( 0.5*((minArea-coord.getArea())/coord.getHeight()))
	else :
		offsetImp = grid.snap( 0.5*((minArea-coord.getArea())/coord.getWidth()))

	offsetImp = 0 if offsetImp < 0 else offsetImp

	if flag == "ew" : 
		box = celResizeRectUnsymmetric2 (coord, offsetImp,0)
	else :
		box = celResizeRectUnsymmetric2 (coord,0, offsetImp)
	
	return box
"""
def celAreaCorrect (coord, minArea, grid, resolution, flag):
	if flag == "ew" :
		offsetImp = grid.snap( 0.5*((minArea-coord.getArea())/coord.getHeight()))
		if ((2*offsetImp + coord.getWidth()) * coord.getHeight()) < minArea :
			offsetImp = offsetImp + resolution
	else :
		offsetImp = grid.snap( 0.5*((minArea-coord.getArea())/coord.getWidth()))
		if ((2*offsetImp + coord.getHeight()) * coord.getWidth()) < minArea :
			offsetImp = offsetImp + resolution
			
	offsetImp = 0 if offsetImp < 0 else offsetImp
	
	if flag == "ew" : 
		box = celResizeRectUnsymmetric2 (coord, offsetImp,0)
	else :
		box = celResizeRectUnsymmetric2 (coord,0, offsetImp)
	
	return box

def celResizeRectUnsymmetric2 (coord, resizeX, resizeY):
	lowerX = coord.getLeft() - resizeX
	lowerY = coord.getBottom() - resizeY
	UpperX = coord.getRight() + resizeX
	UpperY = coord.getTop() + resizeY
	
	return (Box(lowerX, lowerY, UpperX, UpperY))


def celResizeRectUnsymmetric4 ( coord, resizeX1, resizeY1, resizeX2, resizeY2):
	lowerX = coord.getLeft() - resizeX1
	lowerY = coord.getBottom() - resizeY1
	UpperX = coord.getRight() + resizeX2
	UpperY = coord.getTop() + resizeY2	
	return (Box(lowerX, lowerY, UpperX, UpperY)) 
    
def celCreateRingLayer(tapDiffInBox, tapLeft, tapRight, tapTop, tapBottom,tapDiffEnc, diffContEnc, contMinWidth, contMinSpacing, metal1ContEndCap, odMinArea, impMinArea, pinId, tapContacts, cont,diff, metal1, tapImp, grid, resolution) :    	
	    		    	
		tapDiffWidth = 2*diffContEnc + tapContacts * contMinWidth + (tapContacts -1) * contMinSpacing 
	    	diffMetalEnc = diffContEnc - metal1ContEndCap
		
		contOffsetB = -contMinSpacing + diffContEnc if tapBottom == "all" else -diffContEnc
		contOffsetT = -contMinSpacing + diffContEnc if tapTop == "all" else -diffContEnc
		contOffsetL = -contMinSpacing + diffContEnc if tapLeft == "all" else -diffContEnc
		contOffsetR = -contMinSpacing + diffContEnc if tapRight == "all" else -diffContEnc
		
		metalOffsetB = contMinSpacing - metal1ContEndCap if tapBottom == "all" else metal1ContEndCap
		metalOffsetT = contMinSpacing - metal1ContEndCap if tapTop == "all" else metal1ContEndCap
		metalOffsetL = contMinSpacing -  metal1ContEndCap if tapLeft == "all" else metal1ContEndCap
		metalOffsetR = contMinSpacing -  metal1ContEndCap if tapRight == "all" else metal1ContEndCap

		lbFlag = ltFlag = rtFlag= rbFlag= 1
		
		if tapBottom != "none" and tapLeft !="none" :
			lbFlag =-1
		if tapTop != "none" and tapLeft !="none" :
			ltFlag =-1
		if tapTop != "none" and tapRight !="none" :
			rtFlag =-1
		if tapBottom != "none" and tapRight!="none" :
			rbFlag =-1		
	
	    	if tapBottom != "none" :
		    
		    tapDiffBBox  = Box(tapDiffInBox.getLeft(), tapDiffInBox.getBottom() - tapDiffWidth, tapDiffInBox.getRight(), tapDiffInBox.getBottom())
		    tapDiffBRect = Rect (diff,celAreaCorrect (tapDiffBBox, odMinArea, grid, resolution, "ew"))		    
		    
		    
		    if tapBottom == "all" :
			tapContBBox   = celResizeRectUnsymmetric4(tapDiffBBox,contOffsetL,-diffContEnc,contOffsetR,-diffContEnc)
			tapMetalBBox  = celResizeRectUnsymmetric4(tapContBBox ,metalOffsetL,metal1ContEndCap,metalOffsetR,metal1ContEndCap)
			tapMetalBRect = Rect (metal1, tapMetalBBox)
			if pinId != None :
				pinId.addShape(tapMetalBRect)
			
			tapMetalBRect.fillBBoxWithRects( cont,  tapContBBox, width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle= GapStyle.DISTRIBUTE,)
			
		    tapImpBottomBox = celResizeRectUnsymmetric4(tapDiffBBox, lbFlag*tapDiffEnc,tapDiffEnc,rbFlag*tapDiffEnc,tapDiffEnc) 
		    tapImpBottomRect = Rect (tapImp,celAreaCorrect (tapImpBottomBox, impMinArea, grid, resolution, "ew") )
		    
		if tapTop != "none" :
		    
		    tapDiffTBox  = Box(tapDiffInBox.getLeft(), tapDiffInBox.getTop() , tapDiffInBox.getRight(), tapDiffInBox.getTop() + tapDiffWidth)
		    tapDiffTRect = Rect (diff, celAreaCorrect (tapDiffTBox, odMinArea, grid, resolution, "ew"))		    
		    
		    if tapTop == "all" :			
			tapContTBox   = celResizeRectUnsymmetric4( tapDiffTBox, contOffsetL,-diffContEnc, contOffsetR,-diffContEnc)
			tapMetalTBox  = celResizeRectUnsymmetric4(tapContTBox ,metalOffsetL,metal1ContEndCap,metalOffsetR,metal1ContEndCap)
			tapMetalTRect = Rect (metal1, tapMetalTBox)
			if pinId != None :
				pinId.addShape(tapMetalTRect)
			
			tapMetalTRect.fillBBoxWithRects( cont, tapContTBox,width = contMinWidth, height = contMinWidth,spaceX = contMinSpacing, 
			       spaceY = contMinSpacing , gapStyle=GapStyle.DISTRIBUTE,)					    
		    tapImpTopBox = celResizeRectUnsymmetric4(tapDiffTBox, ltFlag*tapDiffEnc,tapDiffEnc,rtFlag*tapDiffEnc,tapDiffEnc)
		    tapImpTopRect = Rect (tapImp, celAreaCorrect (tapImpTopBox, impMinArea, grid, resolution, "ew"))
			
		if tapLeft != "none" :
		    
		    tapDiffLBox  = Box(tapDiffInBox.getLeft() - tapDiffWidth , tapDiffInBox.getBottom() , tapDiffInBox.getLeft(), tapDiffInBox.getTop())
		    tapDiffLRect = Rect (diff, celAreaCorrect (tapDiffLBox, odMinArea, grid, resolution, "ns"))		    
		    
		    if tapLeft == "all" :
		    
			tapContLBox   = celResizeRectUnsymmetric4( tapDiffLBox,-diffContEnc,contOffsetB,-diffContEnc,contOffsetT)
			tapMetalLBox  = celResizeRectUnsymmetric4(tapContLBox,metal1ContEndCap,metalOffsetB,metal1ContEndCap,metalOffsetT)
			tapMetalLRect = Rect (metal1, tapMetalLBox)
			if pinId != None :
				pinId.addShape(tapMetalLRect)
			
			tapMetalLRect.fillBBoxWithRects( cont,  tapContLBox, width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)
		    tapImpLeftBox = celResizeRectUnsymmetric4(tapDiffLBox, tapDiffEnc,lbFlag*tapDiffEnc,tapDiffEnc,ltFlag*tapDiffEnc)
		    tapImpLeftRect = Rect (tapImp, celAreaCorrect (tapImpLeftBox, impMinArea, grid, resolution, "ns"))		    
			
		if tapRight != "none":
		    
		    tapDiffRBox  = Box(tapDiffInBox.getRight(), tapDiffInBox.getBottom() , tapDiffInBox.getRight() + tapDiffWidth, tapDiffInBox.getTop())
		    tapDiffRRect = Rect (diff, celAreaCorrect (tapDiffRBox, odMinArea, grid, resolution, "ns"))		    
		    
		    if tapRight == "all" :			
			tapContRBox   = celResizeRectUnsymmetric4( tapDiffRBox,-diffContEnc,contOffsetB,-diffContEnc,contOffsetT)
			    
			tapMetalRBox  = celResizeRectUnsymmetric4(tapContRBox,metal1ContEndCap,metalOffsetB,metal1ContEndCap,metalOffsetT)
			tapMetalRRect = Rect (metal1, tapMetalRBox)
			if pinId != None :
				pinId.addShape(tapMetalRRect)
			
			tapMetalRRect.fillBBoxWithRects( cont,  tapContRBox, width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)
			 
		    tapImpRightBox = celResizeRectUnsymmetric4(tapDiffRBox, tapDiffEnc,rbFlag*tapDiffEnc,tapDiffEnc,rtFlag*tapDiffEnc)
		    tapImpRightRect = Rect (tapImp,celAreaCorrect (tapImpRightBox, impMinArea, grid, resolution, "ns"))		    
		    
	    	if lbFlag== -1:		    
		    tapDiffBLBox  = Box(tapDiffInBox.getLeft() -tapDiffWidth, tapDiffInBox.getBottom() - tapDiffWidth, tapDiffInBox.getLeft(), tapDiffInBox.getBottom())
		    tapDiffBLRect = Rect(diff, tapDiffBLBox)
		    Rect(tapImp, celResizeRectUnsymmetric2(tapDiffBLBox,tapDiffEnc,tapDiffEnc))
		    
		    if tapBottom == "all" and tapLeft == "all":			
			tapContBLBox   = celResizeRectUnsymmetric2( tapDiffBLBox, -diffContEnc  , -diffContEnc)
			    
			tapMetalBLBox  = celResizeRectUnsymmetric2(tapContBLBox , metal1ContEndCap,metal1ContEndCap)
			tapMetalBLRect = Rect (metal1, tapMetalBLBox)
			tapMetalBLRect.fillBBoxWithRects( cont,  tapContBLBox, width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)
			if pinId != None :		
				pinId.addShape(tapMetalBLRect)

	    	if ltFlag == -1 :		    
		    tapDiffTLBox  = Box(tapDiffInBox.getLeft() -tapDiffWidth, tapDiffInBox.getTop() , tapDiffInBox.getLeft(), tapDiffInBox.getTop() + tapDiffWidth)
		    tapDiffTLRect = Rect(diff, tapDiffTLBox)
		    Rect(tapImp, celResizeRectUnsymmetric4 (tapDiffTLBox, tapDiffEnc, tapDiffEnc, tapDiffEnc, tapDiffEnc))
		    
		    if tapTop == "all" and tapLeft == "all":
			tapContTLBox   = celResizeRectUnsymmetric2( tapDiffTLBox, -diffContEnc  , -diffContEnc)
			tapMetalTLBox  = celResizeRectUnsymmetric2(tapContTLBox , metal1ContEndCap,metal1ContEndCap)
			tapMetalTLRect = Rect (metal1, tapMetalTLBox)
			tapMetalTLRect.fillBBoxWithRects( cont,  tapContTLBox, width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)

			if pinId != None :				
				pinId.addShape(tapMetalTLRect)				

	    	if rtFlag == -1 :		    
		    tapDiffTRBox  = Box(tapDiffInBox.getRight(), tapDiffInBox.getTop() , tapDiffInBox.getRight() +tapDiffWidth, tapDiffInBox.getTop() + tapDiffWidth)
		    tapDiffTRRect = Rect(diff, tapDiffTRBox)
		    Rect(tapImp, celResizeRectUnsymmetric4 (tapDiffTRRect, tapDiffEnc, tapDiffEnc, tapDiffEnc, tapDiffEnc))
		    
		    if tapTop == "all" and tapRight == "all":
			tapContTRBox   = celResizeRectUnsymmetric2( tapDiffTRBox, -diffContEnc  , -diffContEnc)
			tapMetalTRBox  = celResizeRectUnsymmetric2(tapContTRBox , metal1ContEndCap,metal1ContEndCap)
			tapMetalTRRect = Rect (metal1, tapMetalTRBox)
			tapMetalTRRect.fillBBoxWithRects( cont,  tapContTRBox, width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)
			if pinId != None :				
				pinId.addShape(tapMetalTRRect)
			
	    	if rbFlag == -1 :		    
		    tapDiffBRBox  = Box(tapDiffInBox.getRight(), tapDiffInBox.getBottom() - tapDiffWidth, tapDiffInBox.getRight() +tapDiffWidth, tapDiffInBox.getBottom())
		    tapDiffBRRect = Rect(diff, tapDiffBRBox)
		    Rect(tapImp, celResizeRectUnsymmetric4 (tapDiffBRBox, tapDiffEnc, tapDiffEnc, tapDiffEnc, tapDiffEnc))
		    
		    if tapBottom == "all" and tapRight == "all":
			tapContBRBox   = celResizeRectUnsymmetric2( tapDiffBRBox, -diffContEnc  , -diffContEnc)
			tapMetalBRBox  = celResizeRectUnsymmetric2(tapContBRBox , metal1ContEndCap,metal1ContEndCap)
			tapMetalBRRect = Rect (metal1, tapMetalBRBox)
			tapMetalBRRect.fillBBoxWithRects( cont,tapContBRBox,width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)
			if pinId != None :	
				pinId.addShape(tapMetalBRRect)



def celCreateStandard(tapDiffInBox, diffBox4,tapLeft, tapRight, tapTop, tapBottom, dogBoneDiff,extraWidth, tapDiffEnc, tapDiffWidth, diffContEnc, contMinWidth, contMinSpacing, metal1ContEndCap,metal1ContEnclose,odMinArea, impMinArea,pinId, cont,diff,metal1,tapImp,grid, resolution, impButtedTapLeftEnc, impButtedTapRightEnc, buttedTap, buttedTapMetal):

	diffMetalEnc = diffContEnc - metal1ContEndCap
	
	if tapBottom == "all" :
	    tapDiffBBox  = Box( diffBox4.getLeft(), tapDiffInBox.getBottom()-tapDiffWidth, diffBox4.getRight(),tapDiffInBox.getBottom())
	    tapDiffBRect = Rect(diff,celAreaCorrect(tapDiffBBox,odMinArea, grid, resolution, "ew"))
	    tapImpBBox = celResizeRectUnsymmetric2(tapDiffBBox, tapDiffEnc ,tapDiffEnc)
	    tapImpBRect = Rect(tapImp, celAreaCorrect(tapImpBBox,impMinArea, grid, resolution, "ew") )
	    tapContBBox = celResizeRectUnsymmetric2(tapDiffBBox,-diffContEnc, -diffContEnc)	    
	    tapMetalBBox  = celResizeRectUnsymmetric2(tapContBBox , metal1ContEndCap,metal1ContEnclose)
	    tapMetalBRect = Rect (metal1, tapMetalBBox)
	    if pinId != None :
	    	pinId.addShape(tapMetalBRect)
	    tapMetalBRect.fillBBoxWithRects( cont,tapContBBox, width = contMinWidth,height = contMinWidth,spaceX = contMinSpacing, spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)
	    
	if tapTop == "all" :
	    tapDiffTBox  = Box( diffBox4.getLeft(), tapDiffInBox.getTop(), diffBox4.getRight(),tapDiffInBox.getTop() + tapDiffWidth)
	    tapDiffTRect = Rect(diff,celAreaCorrect(tapDiffTBox,odMinArea, grid, resolution, "ew"))
	    tapImpTBox = celResizeRectUnsymmetric2(tapDiffTBox, tapDiffEnc ,tapDiffEnc)
	    tapImpTRect = Rect(tapImp, celAreaCorrect(tapImpTBox,impMinArea, grid, resolution, "ew"))
	    tapContTBox = celResizeRectUnsymmetric2( tapDiffTBox,-diffContEnc, -diffContEnc)
	    tapMetalTBox  = celResizeRectUnsymmetric2(tapContTBox , metal1ContEndCap,metal1ContEnclose)
	    tapMetalTRect = Rect (metal1, tapMetalTBox)
	    if pinId != None :
	    	pinId.addShape(tapMetalTRect)
	    tapMetalTRect.fillBBoxWithRects( cont,tapContTBox,width = contMinWidth,height = contMinWidth,spaceX = contMinSpacing, spaceY = contMinSpacing,gapStyle=GapStyle.DISTRIBUTE,)
	    
	if tapLeft == "all" :
	    if dogBoneDiff :
		extraWidth = 0
	    tapDiffLBox  = Box( tapDiffInBox.getLeft()-tapDiffWidth,diffBox4.getBottom(),tapDiffInBox.getLeft(), diffBox4.getTop())
	    if buttedTap :
	        tapDiffLRect = Rect(diff, tapDiffLBox)
	    else :
	        drawTapDiffLBox  = celAreaCorrect(tapDiffLBox,odMinArea, grid, resolution, "ns")
	        tapDiffLRect = Rect(diff, drawTapDiffLBox)
	    tapImpLBox = celResizeRectUnsymmetric4(tapDiffLBox, tapDiffEnc, tapDiffEnc, impButtedTapLeftEnc, tapDiffEnc)
	    tapImpLRect = Rect(tapImp,celAreaCorrect(tapImpLBox,impMinArea, grid, resolution, "ns"))
	    tapContLBox = celResizeRectUnsymmetric4( tapDiffLBox,-diffContEnc, -extraWidth -diffContEnc,-diffContEnc, -extraWidth -diffContEnc)
	    tapMetalLBox  = celResizeRectUnsymmetric2(tapContLBox , metal1ContEnclose,metal1ContEndCap)
	    tapMetalLRect = Rect (metal1, tapMetalLBox)
	    if pinId != None :
	    	pinId.addShape(tapMetalLRect)
	    tapMetalLRect.fillBBoxWithRects( cont,tapContLBox,width = contMinWidth,height = contMinWidth,spaceX = contMinSpacing, 
		   spaceY = contMinSpacing,gapStyle=GapStyle.DISTRIBUTE,)		
	
	if tapRight == "all" :
	    if dogBoneDiff :
		extraWidth = 0
	    tapDiffRBox  = Box( tapDiffInBox.getRight(),diffBox4.getBottom(),tapDiffInBox.getRight() +tapDiffWidth, diffBox4.getTop())
	    if buttedTap :
	        tapDiffRRect = Rect(diff, tapDiffRBox)
	    else :
	        drawTapDiffRBox  = celAreaCorrect(tapDiffRBox,odMinArea, grid, resolution, "ns")
	        tapDiffRRect = Rect(diff, drawTapDiffRBox)
	    tapImpRBox = celResizeRectUnsymmetric4(tapDiffRBox, impButtedTapRightEnc, tapDiffEnc, tapDiffEnc, tapDiffEnc)
	    tapImpRRect = Rect(tapImp, celAreaCorrect(tapImpRBox,impMinArea, grid, resolution, "ns"))
	    tapContRBox = celResizeRectUnsymmetric4( tapDiffRBox, -diffContEnc, -extraWidth -diffContEnc, -diffContEnc, -extraWidth -diffContEnc)
	    tapMetalRBox  = celResizeRectUnsymmetric2(tapContRBox , metal1ContEnclose,metal1ContEndCap)
	    tapMetalRRect = Rect (metal1, tapMetalRBox)
	    if pinId != None :
	    	pinId.addShape(tapMetalRRect)
	    tapMetalRRect.fillBBoxWithRects( cont,tapContRBox, width = contMinWidth, height = contMinWidth, spaceX = contMinSpacing, 
		   spaceY = contMinSpacing, gapStyle=GapStyle.DISTRIBUTE,)	


###############################################################################
class LayerDict( Dictionary):
    """Dictionary of Layer objects.  None is a valid value for a key.
        """

    ####################################################################

    def __init__(
        self,
        technology,
        layerMapping):

        super( LayerDict, self).__init__()

        for (key, value) in layerMapping.iteritems():
            if value:
                self[ key] = technology.getLayer( *value)
            else:
                self[ key] = value


##########################################################################
def convertScaledNumberString(self, paramString):
        if paramString[-1] in cdfNumeric.scaling_factors:
                param = float(cdfNumeric(paramString)) / float(cdfNumeric.scaling_factors['u']) 
        else:
                param = float(cdfNumeric(paramString))
        # also ensure that this converted value lies on grid point
        grid = Grid(self.tech.getGridResolution())
        param = grid.snap(param)
        return(param)

##########################################################################
        # Converts the property bag into a Scaled Number if the property is there in the pbag, else its assigned to 0.
def convertType (self, pBag, value):
        if pBag.has_key(value):
                return (convertScaledNumberString(self,pBag[value]))
        else:
                return 0.0
##########################################################################
