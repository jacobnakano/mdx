#######################################################################
#                                                                      #
# MosUtils.py                                                          #
#                                                                      #
########################################################################
"""Module: MosUtils

This module implements a utility classes for creating stacked
MOS transistors.

MosUtil classes are building blocks which can be used for creating
MOS device PyCells, or groups of devices as used in standard
cells.

Module dependencies:
	- cni.dlo            Ciranova PyCell APIs.
	- cni.integ.common   Ciranova integration APIs.
	- copy               Python copy
	"""
from __future__ import with_statement

__version__  = "$Revision: 0.1 $"
__fileinfo__ = "$Id: MosUtils.py,v 0.1 2008/08/22 18:32:06 $"
__author__   = "Suresh P/Soumya D"

########################################################################
#                                                                      #
# Packages                                                             #
#                                                                      #
########################################################################

import cni
from cni.dlo import (
	AbutContact,
	Bar,
	Box,
	CompoundComponent,
	Contact,
	Dot,
	DeviceContext,
	DeviceContextManager,
	Direction,
	DloGen,
	GapStyle,
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
cni.utils.importConstants(Direction)

from cni.integ.common import (
	Compare,
	Dictionary,
	isEven,
	isOdd,
	renameParams,
	stretchHandle,
)

import copy
import math
import time

SCRATCHPAD = ( -5, -5)

########################################################################
#                                                                      #
# Utility Classes and Methods                                          #
#                                                                      #
########################################################################

####################################################################

def orderedRuleset(
	tech,
	rulesets):
	"""Return name of first ruleset in an ordered list which exists
	in the technology file.
		"""
	techRulesets = [ ruleset.name for ruleset in tech.getRulesets()]

	for name in rulesets:
		if name in techRulesets:
			return( name)

	raise ValueError, "No supported ruleset found."

########################################################################

def shrinkBox(box, minHeight, shrink):
		"""
Shrink box by shrink description, especially for SDshrink parameter
(notUsed upperShrink lowerShrink halfSideShrink notUsed)
		"""
		hasShrunk = False
		topShrink = shrink[1]
		botShrink = shrink[2]
		sideShrink = shrink[3]
		# Shrink bottom and top
		if botShrink or topShrink:
			hasShrunk = True
			boxTop = box.getTop()
			boxBottom = box.getBottom()
			# Shrink bottom first
			maxBoxBottom = boxTop - minHeight
			boxBottom += botShrink
			if boxBottom > maxBoxBottom:
				boxBottom = maxBoxBottom
			box.setBottom(boxBottom)
			# Shrink top
			minBoxTop = boxBottom + minHeight
			boxTop -= topShrink
			if boxTop < minBoxTop:
				boxTop = minBoxTop
			box.setTop(boxTop)
		# Shrink side
		if sideShrink > 0:
			box.expand(EAST_WEST, 0.5*sideShrink)
			hasShrunk = True
		return hasShrunk

########################################################################

class NoManager( object):
	"""An empty class which acts as a stub when no valid Ruleset or
	DeviceContext is found in the technology file.
		"""
	def __enter__( self):
		pass

	def __exit__( self, unknown1, unknown2, unknown3):
		pass

def rulesmgr(
	tech,
	context,
	namesGiven):
	"""Return first ruleset or device context found which exists in the
	technology file.
		"""
	search = {
		Ruleset       : ("getRulesets",       RulesetManager      ),
		DeviceContext : ("getDeviceContexts", DeviceContextManager),
	}

	mgr = NoManager()

	if namesGiven:
		if not isinstance( namesGiven, list):
			namesGiven = [ namesGiven]

		# Find the matching ruleset or device context.
		namesFound = [ item.name for item in getattr( tech, search[ context][0])()]
		for name in namesGiven:
			if name in namesFound:
				mgr = search[ context][1]( tech, name)
				break

		if context == Ruleset:
			# Valid condition to request a ruleset which does not exist.
			pass
		elif context == DeviceContext:
			# Error condition to request a device context which does not exist.
			if isinstance( mgr, NoManager):
				raise ValueError, "No valid device context - %s" % namesGiven
		else:
			raise ValueError, "Illegal technology context - %s" % context

	return( mgr)

########################################################################

class LayerDict(object):
	"""Dictionary of Layer objects.  None is a valid value for a key.
		"""

	####################################################################

	def __init__(
		self,
		technology,
		layerMapping):

		for (key, value) in layerMapping.iteritems():
			setattr(self, key, technology.getLayer(*value) if value else None)

########################################################################

class Pattern( object):
	"""A set of methods for generating patterns useful in wiring Mosfets
	in configurations such as a differential pair.
		"""

	####################################################################

	@staticmethod
	def all(
		limit):
		"""Return list integers, 0 <= i < limit.
			"""
		return( range( 0, limit))

	####################################################################

	@staticmethod
	def even(
		limit):
		"""Return list of even-valued integers, 0 <= i < limit.
			"""
		return( range( 0, limit, 2))

	####################################################################

	@staticmethod
	def diffPairContact(
		fingersPerRow):
		"""Return a dictionary of lists.  Each list is a sequence
		describing how contacts are assigned for each device in a
		differential pair.
			"""
		pattern = Dictionary(
			c0 = [],    # Contact for device0
			c1 = [],    # Contact for device1
			c2 = [],    # Contact for shared node
			c  = [],    # All contacts
		)
		contacts = (2 * fingersPerRow) + 1



		# Assignment for shared node
		if isEven( fingersPerRow):
			i = 0
		else:
			i = 1

		for x in range( i, contacts, 2):
			pattern.c2.append( x)



		# Assignment for device0 contact
		if isEven( fingersPerRow):
			i = 1
		else:
			i = 0

		for x in range( i, contacts, 4):
			pattern.c0.append( x)



		# Assignment for device1 contact
		if isEven( fingersPerRow):
			i = 3
		else:
			i = 2

		for x in range( i, contacts, 4):
			pattern.c1.append( x)



		# Summary pattern
		pattern.c.extend( [ 0 for i in range( contacts)])

		for i in pattern.c1:
			pattern.c[ i] = 1

		for i in pattern.c2:
			pattern.c[ i] = 2

		return( pattern)

	####################################################################

	@staticmethod
	def diffPairGate(
		fingersPerRow):
		"""Return a dictionary of lists.  Each list is a sequence
		describing how gates are assigned for each device in a
		differential pair.
			"""
		pattern = Dictionary(
			g0 = [],    # Gates for device0
			g1 = [],    # Gates for device1
			g  = [],    # All gates
		)
		gates = 2 * fingersPerRow



		# Assignment for device0
		i  = 0
		pattern.g0.append( i)
		i  += 1

		if isEven( fingersPerRow):
			pattern.g0.append( i)
			i += 1

		i += 2
		for x in range( i, gates, 4):
			pattern.g0.extend( [x, x+1])



		# Assignment for device1
		i  = gates
		i  -= 1
		pattern.g1.append( i)

		if isEven( fingersPerRow):
			i -= 1
			pattern.g1.append( i)

		i -= 3
		for x in range( i, 0, -4):
			pattern.g1.extend( [x, x-1])
		pattern.g1.reverse()



		# Summary pattern
		pattern.g.extend( [ 0 for i in range( gates)])
		for i in pattern.g1:
			pattern.g[ i] = 1

		return( pattern)

	####################################################################

	@staticmethod
	def odd(
		limit):
		"""Return list of odd-valued integers, 0 <= i < limit.
			"""
		return( range( 1, limit, 2))

	####################################################################

	@staticmethod
	def repeat(
		subpattern,
		count):
		"""Return list of repeating pattern.  list length = count.
			"""
		length  = len( subpattern) - 1
		pattern = []

		i = 0
		j = 0
		while ( i < count):
			pattern.append( subpattern[ j])
			i += 1
			if j < length:
				j += 1
			else:
				j = 0

		return( pattern)

########################################################################

class RouteRect( Rect):
	"""Create a connecting rectangle between 2 RouteTargets which are
	restricted to being single layer rectangles.  This class is not
	functionally equivalent to RoutePath.  RoutePath is more full
	featured, but resulted in a restriction that the RouteTarget width
	must be an even multiple of the layout grid.

	fromTarg bounding box sets the width of the rectangle.
		"""

	####################################################################

	def __init__(
		self,
		layer,
		box):

		Rect.__init__(self, layer, box)

	####################################################################

	@staticmethod
	def connect(
		sources,
		destination,
		layer,
		direction,
		bound = None):
		"""Create connecting RouteRect(s).  Returns a list.
		source may be a list or tuple.  destination is a PhysicalComponent.
			"""
		rects = []
		if isinstance( destination, Box):
			dBox  = destination
		else:
			dBox  = destination.getBBox( layer)

		if direction == NORTH:
			top = dBox.getBottom()
			for source in sources:
				sBox   = source.getBBox( layer)
				bottom = bound if bound else top
				bottom = min( sBox.getTop(), bottom)
				left   = sBox.getLeft()
				right  = sBox.getRight()
				if top > bottom:
					rects.append( RouteRect( layer, Box( left, bottom, right, top)))

		elif direction == SOUTH:
			bottom = dBox.getTop()
			for source in sources:
				sBox   = source.getBBox( layer)
				top    = bound if bound else bottom
				top    = max( sBox.getBottom(), top)
				left   = sBox.getLeft()
				right  = sBox.getRight()
				if top > bottom:
					rects.append( RouteRect( layer, Box( left, bottom, right, top)))

		elif direction == EAST:
			right = dBox.getLeft()
			for source in sources:
				sBox   = source.getBBox( layer)
				top    = sBox.getTop()
				bottom = sBox.getBottom()
				left   = bound if bound else right
				left   = min( sBox.getRight(), left)
				if right > left:
					rects.append( RouteRect( layer, Box( left, bottom, right, top)))

		elif direction == WEST:
			left = dBox.getRight()
			for source in sources:
				sBox   = source.getBBox( layer)
				top    = sBox.getTop()
				bottom = sBox.getBottom()
				right  = bound if bound else left
				right  = max( sBox.getLeft(), right)
				if right > left:
					rects.append( RouteRect( layer, Box( left, bottom, right, top)))

		else:
			raise ValueError, "direction must be one of (NORTH,SOUTH,EAST,WEST)."

		return( rects)

########################################################################

class RulesDict(object):
	"""
Rule Dictionary using native Python object for fast cashing of design rules.
Values are not restricted to single float values. I.e.
rulesDict.ruleName = value
		"""

########################################################################
#                                                                      #
# Classes of Transistor Parts                                          #
#                                                                      #
########################################################################

class MosCC( CompoundComponent):
	"""Parent class for other MosUtils CompoundComponents.
		"""

	####################################################################

	def __init__(
		self,
		params):
		"""Manage instance attributes for technology.
			"""
		CompoundComponent.__init__(self, Unique.Name( "%s_" % self.__class__.__name__))

		# TODO, Try not to modify params to get less expensive usage below
		# self.params = params
		del params["self"]
		self.params = Dictionary( **params)

########################################################################

class ContactCC( MosCC):
	"""Parent class for a single row/column Contact.
		"""

	####################################################################

	def __init__(
		self,
		lowerLayer,
		upperLayer,
		viaLayer,
		width,
		implement,
		rules,
		pt0       = None,
		direction = NORTH):
		"""Create self.params instance attribute to store constructor
		arguments.  Create layout.
			"""
		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		MosCC.__init__(self, locals())
		getattr(self, implement)()
		self.lock()

	####################################################################

	def setPin(
		self,
		pinName,
		termName,
		layers=None):
		"""Create pins for upper and lower rectangles.
			"""
		pin = Pin.find( pinName)
		if not pin:
			pin = Pin( pinName, termName)

		rects = [ c for c in self.pinShapes if c.getLayer() in layers]

		# Different shapes on same pin => strong connect
		pin.addShape( rects)

########################################################################

class MosContact( MosCC):
	"""Device contact consisting of a lower level rectangle, such
	as diffusion or poly layer, and a composite contact object,
	either a CompoundComponent or PyCell.
		"""


	####################################################################

	def setPin(
		self,
		pinName,
		termName,
		layers=None):
		"""Create pins for lower layer rectangle and contact.
			"""
		pin   = Pin.find( pinName)
		if not pin:
			pin = Pin( pinName, termName)

		pin.addShape( self.lowerRect)
		self.contact.setPin(
			pinName  = pinName,
			termName = termName,
			layers   = [ self.params.upperLayer],
		)

########################################################################

class ContactGate( MosContact):
	"""Parent class for gate contacts.  Consists of contact composite
	object and poly rectangle.  Contacts are arranged in a single
	row.

	width is size of lower level rectangle.  coverage determines how
	much of poly rectangle is covered with contacts.
		"""

########################################################################

class ContactGate7( ContactGate):
	"""
# Fast version of ContactGate6
	Create a ContactGate using ContactCC.construct2.  Upper layer
	dimension sized as requested, then filled the maximum number of
	equally spaced contacts.  Based on coverage.
		"""

	####################################################################

	def __init__(
		self,
		lowerLayer,
		upperLayer,
		width,  # Min width of lower-layer
		direction = NORTH,  # NORTH(_EAST) or SOUTH(_WEST) depending
							# on expansion from pt0
							# Direction is from gate finger to self.
		pt0       = None,   # Reference point of lowerLayer box.
							# Use lowerLeft point for direction=NORTH,
							# upperRight point for direction=SOUTH
		genContact = True,  # Generate upper layer for Contact
		):
		# Create Contact for gate-landing in NORTH side or SOUTH side
		# of gate fingers

		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		ContactGate.__init__(self, locals())
		curDloGen = DloGen.currentDloGen()
		self.params.viaLayer = curDloGen.layer.contact

		self.construct()
		self.lock()

	def construct(
		self):
		"""
# Fast version of MosContact.construct()
		Build the layout.
			"""
		params = self.params
		curDloGen = DloGen.currentDloGen()
		curDloGenLayer = curDloGen.layer
		lowerLayer = curDloGenLayer.poly

		rules = curDloGen.rules
		dfmRules = curDloGen.dfmRules

		direction = params.direction
		# Direction multiplier for coordinate expansion
		directionMult = 1 if direction == NORTH else -1
		# Create lower layer rect
		pt0 = params.pt0
		x, y = pt0.getX(), pt0.getY()
		lowerBoxWidth = lowerBoxHeight = rules.minWidthPolyEncContact
		width = params.width
		# mustAlignContact indicates Contact must be center aligned
		# with respect to transistor fingers.
		mustAlignContact = True if width < rules.minWidthPolyEncContact else False
		if not mustAlignContact:
			lowerBoxWidth = width
		lowerBox = Box(x, y, x+directionMult*lowerBoxWidth, y+directionMult*lowerBoxHeight)
		lowerBox.fix()
		if mustAlignContact:
			refBox = Box(x, 0, x+directionMult*width, 0)
			refBox.fix()
			lowerBox.alignEdge(EAST_WEST, refBox)
		self.lowerRect = Rect(lowerLayer, lowerBox)
		self.add( self.lowerRect)
		self.pinShapes = [ self.lowerRect]

		# Create upper layer rect
		if params.genContact:
			# Compute viaFillBox and cuts
			viaLayer = curDloGenLayer.contact
			viaFillBox = Box(lowerBox)
			lowerEnc = rules.polyExtContact
			viaFillBox.expand(-lowerEnc)
			viaWidth  = rules.contactWidth
			viaSpace  = rules.contactSpace
			Rect.fillBBoxWithRects(viaLayer, viaFillBox, viaWidth, viaWidth,
				viaSpace, viaSpace, GapStyle.DISTRIBUTE)

			# Compute upperBox
			upperLayer = curDloGenLayer.metal1
			upperBox = Box(lowerBox.getLeft(), viaFillBox.getBottom(), lowerBox.getRight(), viaFillBox.getTop())
			upperEnc = rules.metal1ExtContact
			upperBox.expand(NORTH_SOUTH, upperEnc)
			self.upperRect = upperRect = Rect(upperLayer, upperBox)
			self.pinShapes.append(upperRect)
			self.add(self.upperRect)

	####################################################################

	def setPin(
		self,
		pinName,
		termName,
		layers=None):
		"""Create pins for lower layer rectangle.
			"""
		pin   = Pin.find( pinName)
		if not pin:
			pin = Pin( pinName, termName)

		pin.addShape( self.lowerRect)

########################################################################

class ContactCenter( MosContact):
	"""Parent class for center source/drain diffusion contact.  Consists
	of a composite contact object and a diffusion rectangle.  Contacts
	are arranged in a single column.

	width is size of lower level rectangle.  coverage determines how
	much of diffusion rectangle is covered with contacts.
		"""

########################################################################

class ContactCenter7( ContactCenter):
	"""
# Fast version of ContactCenter6
	Create a ContactCenter using ContactCC.construct2.  Upper layer
	dimension sized as requested, then filled the maximum number of
	equally spaced contacts.  Based on coverage.
		"""
	####################################################################

	def __init__(
		self,
		lowerLayer,
		upperLayer,
		gateLayer,
		width,
		gateSpace,
		sdShrink,
		pt0                = None,
		genContact = True    # Generate upper layer for Contact
		):
		"""Create the layout.  Locate the contact.
			"""
		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		ContactCenter.__init__(self, locals())
		curDloGen = DloGen.currentDloGen()
		self.params.viaLayer = curDloGen.layer.contact
		self.params.isDogbone = curDloGen.topo.isDogbone

		self.construct()
		self.lock()

	def construct(
		self):
		"""
# Fast version of MosContact.construct()
		Build the layout.
			"""
		params = self.params
		self.contact = contact = MosSDCenter(
			width      = params.width,
			gateSpace  = params.gateSpace,
			upperShrink   = params.sdShrink,
			isDogbone     = params.isDogbone,
			pt0        = params.pt0,
			genContact = params.genContact
		)
		self.add(contact)
		self.lowerRect = contact.lowerRect

########################################################################

class ContactEdge( MosContact):
	"""Parent class for right/left edge source/drain diffusion contact.
	Consists of contact composite object and a diffusion rectangle.
	Contacts are arranged in a single column.

	width is size of lower level rectangle.  coverage determines how
	much of diffusion rectangle is covered with contacts.
		"""

########################################################################

class ContactEdge7( ContactEdge):
	"""
# Fast version of ContactEdge6.
		"""

	####################################################################

	def __init__(
		self,
		abutment,
		lowerLayer,
		upperLayer,
		gateLayer,
		width,
		gateLength,
		sdShrink,
		varSpace,
		orient             = Orientation.R0,
		pt0                = None,
		genContact         = True,
		abutWellTap        = False,
		):
		"""
Create the layout.  Locate the contact.
pt0: lower-left point of Contact
		"""

		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		ContactEdge.__init__(self, locals())
		curDloGen = DloGen.currentDloGen()
		self.params.viaLayer = curDloGen.layer.contact
		self.params.isDogbone = curDloGen.topo.isDogbone

		self.construct()
		self.lock()

	def construct(
		self):
		"""
# Fast version of MosContact.construct()
		Build the layout.
			"""
		params = self.params
		self.contact = contact = MosSDEdge(
			abutment   = params.abutment,
			width      = params.width,
			orient     = params.orient,
			upperShrink   = params.sdShrink,
			varSpace     = params.varSpace,
			isDogbone     = params.isDogbone,
			pt0        = params.pt0,
			genContact = params.genContact,
			abutWellTap = params.abutWellTap
		)
		self.add(contact)
		self.lowerRect = contact.lowerRect

########################################################################

class MosSDCenter(MosCC):
	"""
# Fast version of ContactCC
	Source-Drain Contact containing M1 to Diff
	"""

	####################################################################
	def __init__(
		self,
		width,      # Gate width
		gateSpace,  # Gate to gate spacing
		upperShrink,    # Upper layer shrink
		isDogbone,      # Dogbone transistor
		pt0 = None,     # Location of finger on left of MosSDCenter
		genContact = True,   # Generate upper layer Contact
		):
		"""Create self.params instance attribute to store constructor
		arguments.  Create layout.
			"""
		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		MosCC.__init__(self, locals())
		self.construct()
		self.lock()

	####################################################################
	def construct(
		self):
		"""
Fast version of ContactCC.construct2
Build single column contact, containing rectangles.
Placement of cuts is equally spaced,
		"""
		params = self.params
		curDloGen = DloGen.currentDloGen()
		curDloGenLayer = curDloGen.layer
		lowerLayer = curDloGenLayer.diffusion

		rules = curDloGen.rules
		dfmRules = curDloGen.dfmRules

		# Create lower layer rect
		pt0 = params.pt0
		x, y = pt0.getX(), pt0.getY()
		lowerBox = Box(x, y, x + params.gateSpace, y + params.width)
		isDogbone = params.isDogbone
		if isDogbone:
			lowerBox.expand(EAST_WEST, -rules.polyClrDiffForGate)
			lowerBox.setTop(rules.minWidthDiffEncContact)
			gateBox = Box(0,0,0, params.width)
			lowerBox.alignEdge(NORTH_SOUTH, gateBox)
			lowerBox.snapTowards(curDloGen.grid, NORTH)
		self.lowerRect = lowerRect = Rect(lowerLayer, lowerBox)
		self.pinShapes = [lowerRect]
		self.add(lowerRect)

		if params.genContact:
			# Generate metal Contact and cuts
			upperLayer = curDloGenLayer.metal1
			viaLayer = curDloGenLayer.contact
			lowerEnc = rules.diffExtContact
			upperEnc = rules.metal1ExtContact
			upperEndEnc = rules.metal1EndExtContact

			# Compute viaFillBox
			viaFillBox = Box(lowerBox)
			viaFillBox.expand(NORTH_SOUTH, -lowerEnc)
			viaFillBoxHorzEncByLowerBox = rules.contactClrGate if not isDogbone else lowerEnc
			viaFillBox.expand(EAST_WEST, -(viaFillBoxHorzEncByLowerBox
				+0.5*dfmRules.fingers_SP_INC+0.5*dfmRules.DGA_GA_SP_INC))
			# Compute upperBox
			upperBox = Box(viaFillBox)
			upperBox.expand(EAST_WEST, upperEnc)
			upperBox.expand(NORTH_SOUTH, upperEndEnc)
			# Adjust for upperShrink
			hasShrunk = shrinkBox(upperBox,
				rules.minWidthMetal1EndExtContact, params.upperShrink)
			self.upperRect = upperRect = Rect(upperLayer, upperBox)
			self.pinShapes.append(upperRect)
			self.add(self.upperRect)
			# Generate via cuts
			viaWidth  = rules.contactWidth
			viaSpace  = rules.contactSpace + params.upperShrink[4]
			if hasShrunk:
				viaFillBox.set(upperBox)
				viaFillBox.expand(NORTH_SOUTH, -upperEndEnc)
				viaFillBox.expand(EAST_WEST, -upperEnc)
			Rect.fillBBoxWithRects(viaLayer, viaFillBox, viaWidth, viaWidth,
				viaSpace, viaSpace, GapStyle.DISTRIBUTE)

	####################################################################

	def setPin(
		self,
		pinName,
		termName,
		layers=None):
		"""Create pins for upper and lower rectangles.
			"""
		pin = Pin.find( pinName)
		if not pin:
			pin = Pin( pinName, termName)

		rects = [ c for c in self.pinShapes if c.getLayer() in layers]

		# Different shapes on same pin => strong connect
		pin.addShape( rects)

########################################################################

class MosSDEdge(MosCC):
	"""
# Fast version of ContactCC
	Source-Drain Contact containing M1 to Diff
	"""

	####################################################################
	def __init__(
		self,
		abutment,   # Abutment style
		width,  # Gate width
		orient, # Orientation is R0 for left edge or MY for right
		upperShrink,    # Upper layer shrink
		isDogbone,      # Dogbone transistor
		varSpace,
		pt0 = None,     # Location of finger on left of MosSDEdge
		genContact = True,   # Generate upper layer Contact
		abutWellTap = False,    # Abutting to well tap.
		):
		"""Create self.params instance attribute to store constructor
		arguments.  Create layout.
			"""
		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		MosCC.__init__(self, locals())
		self.construct()
		self.lock()

	####################################################################
	def construct(
		self):
		"""
Fast version of ContactCC.construct2
Build single column contact, containing rectangles.
Placement of cuts is equally spaced,
			"""
		params = self.params
		curDloGen = DloGen.currentDloGen()
		curDloGenLayer = curDloGen.layer
		lowerLayer = curDloGenLayer.diffusion

		rules = curDloGen.rules
		dfmRules = curDloGen.dfmRules

		# Create lower layer rect
		pt0 = params.pt0
		x, y = pt0.getX(), pt0.getY()
		
		orient = params.orient
		# Direction with respect to Gate finger from self 
		if orient == Orientation.R0:
			dirToGate = EAST
			dirAwayGate = WEST
			directionMult = -1
		else:
			dirToGate = WEST
			dirAwayGate = EAST
			directionMult = 1
		# Direction multiplier for coordinate expansion
		isDogbone = params.isDogbone
		abutWellTap = params.abutWellTap

		# lowerBoxSpace is lowerBox spacing from gate finger
		# lowerBoxDx is lowerBox width displacement in X dir
		lowerBoxSpace = 0
		# Determine width of lowerLayer depending on abutment type and dogbone
		abutment = params.abutment
		# Contact can be disabled depending on abutment
		disableContact = False
		
		if abutment in ("normal", "smallExt", "largeExt", "No_abutment"):
			# Handle dogbone later
			lowerBoxDx = rules.contactWidth + rules.contactClrGate + rules.diffExtContact
		elif abutment == "same":
			#lowerBoxDx = curDloGen.grid.snap(0.5*rules.gateSpace)
			lowerBoxDx = 0.09
				
			disableContact = True
		elif abutment == "sameExt":
			# Handle dogbone now
			if isDogbone:
				lowerBoxDx = rules.polyClrDiffForGate
			else:
				lowerBoxDx = rules.contactClrGate - rules.diffExtContact
			if lowerBoxDx < curDloGen.maskgrid:
				lowerBoxDx = curDloGen.maskgrid
			disableContact = True
		elif abutment == "small":
			lowerBoxDx = rules.polyClrDiffForGate
			
			disableContact = True
		elif abutment == "large":
			lowerBoxDx = rules.diffExtPoly
			disableContact = True
		elif abutment == "diff":
			lowerBoxDx = rules.od2ClrGate
			disableContact = True
		elif abutment == "diffExt":
			# Handle dogbone later
			lowerBoxDx = rules.od2ClrGate

		# Integrated well tap case
		if abutWellTap:
			# Handle dogbone later
			lowerBoxDx = rules.tapClrGate

		if not disableContact:
			lowerBoxSpace += dfmRules.LGA_CO_SP_INC if dirToGate == EAST else dfmRules.RGA_CO_SP_INC
			if isDogbone:
				# Adjust spacing of diff from gate for dogbone
				lowerBoxSpace += rules.polyClrDiffForGate
				# Adjust lowerBoxWidth for dogbone
				lowerBoxWidthForDogbone = rules.minWidthDiffEncContact
				lowerBoxWidthAndSpaceForDogbone = lowerBoxWidthForDogbone + rules.polyClrDiffForGate
				if lowerBoxDx < lowerBoxWidthAndSpaceForDogbone:
					lowerBoxDx = lowerBoxWidthForDogbone
				else:
					lowerBoxDx -= rules.polyClrDiffForGate

		# Spacing and width of lower layer box from gate
		if dirToGate == WEST:
			lowerBoxSpace = -lowerBoxSpace
			lowerBoxDx = -lowerBoxDx
		
		lowerBoxEdgeFromGate = x - lowerBoxSpace
		lowerBox = Box(lowerBoxEdgeFromGate, y, lowerBoxEdgeFromGate - lowerBoxDx, y + params.width)
		lowerBox.fix()
		if isDogbone and not disableContact:
			lowerBox.setTop(rules.minWidthDiffEncContact)
			gateBox = Box(0,0,0, params.width)
			lowerBox.alignEdge(NORTH_SOUTH, gateBox)
			lowerBox.snapTowards(curDloGen.grid, NORTH)
		self.lowerRect = lowerRect = Rect(lowerLayer, lowerBox)
		self.pinShapes = [lowerRect]
		self.add(lowerRect)
		
		if params.genContact and not disableContact:
			# Generate metal Contact and cuts
			upperLayer = curDloGenLayer.metal1
			viaLayer = curDloGenLayer.contact
			lowerEnc = rules.diffExtContact
			upperEnc = rules.metal1ExtContact
			upperEndEnc = rules.metal1EndExtContact
			

			# Compute viaFillBox
			viaFillBox = Box(lowerBox)
			viaFillBox.expand(NORTH_SOUTH, -lowerEnc)
			# viaFillBox horz enc by lowerBox toward gate
			# Default is to enclose 1 horz via.
			viaFillBoxHorzEncByLowerBoxToGate = rules.contactClrGate if not isDogbone else lowerEnc
			viaFillBox.expand(dirToGate, -viaFillBoxHorzEncByLowerBoxToGate)
			viaWidth  = rules.contactWidth
			viaFillBox.setCoord(dirAwayGate, viaFillBox.getCoord(dirToGate) +
				directionMult*viaWidth)
			# Compute upperBox
			upperBox = Box(viaFillBox)
			upperBox.expand(EAST_WEST, upperEnc)
			upperBox.expand(NORTH_SOUTH, upperEndEnc)
			# Adjust for upperShrink
			hasShrunk = shrinkBox(upperBox,
				rules.minWidthMetal1EndExtContact, params.upperShrink)
			self.upperRect = upperRect = Rect(upperLayer, upperBox)
			if dirToGate == WEST:
					rules.upperRect1 = upperRect
			else:
					rules.upperRect = upperRect
			self.pinShapes.append(upperRect)
			self.add(self.upperRect)
			# Generate via cuts
			#viaSpace  = rules.contactSpace + params.upperShrink[4]
			viaSpace  = params.varSpace + params.upperShrink[4]
			
			
			if hasShrunk:
				viaFillBox.set(upperBox)
				viaFillBox.expand(NORTH_SOUTH, -upperEndEnc)
				viaFillBox.expand(EAST_WEST, -upperEnc)
			Rect.fillBBoxWithRects(viaLayer, viaFillBox, viaWidth, viaWidth,
				viaSpace, viaSpace, GapStyle.DISTRIBUTE)

	####################################################################

	def setPin(
		self,
		pinName,
		termName,
		layers=None):
		"""Create pins for upper and lower rectangles.
			"""
		pin = Pin.find( pinName)
		if not pin:
			pin = Pin( pinName, termName)

		rects = [ c for c in self.pinShapes if c.getLayer() in layers]

		# Different shapes on same pin => strong connect
		pin.addShape( rects)

########################################################################

class ContactSubstrate( MosContact):
	"""Parent class for a substrate contact.  Consists of contact
	composite object and a diffusion rectangle.  Contacts are arranged
	in a single column.

	width is size of lower level rectangle.  coverage determines how
	much of diffusion rectangle is covered with contacts.
		"""
########################################################################

class ContactSubstrate7( ContactSubstrate):
	"""
# Fast version of ContactSubstrate6.
		"""

	####################################################################

	def __init__(
		self,
		lowerLayer,
		upperLayer,
		implantLayer,   # Bulk implant layer.
		width,  # width of finger
		varSpace,
		direction          = WEST,  # WEST or EAST depending on expansion
									# from pt0.
									# Direction is from gate finger to self.
		integrated  = False, # Integrated or detached Bulk Contact.
		flush = False,      # Flush implant for Integrated.
		pt0       = None,   # Reference point of lowerLayer box.
							# Use lowerRight point for direction=WEST,
							# lowerLeft point for direction=EAST
		):
		"""Create the layout.  Locate the contact.
			"""
		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		ContactSubstrate.__init__(self, locals())
		curDloGen = DloGen.currentDloGen()
		self.params.viaLayer = curDloGen.layer.contact
		self.params.isDogbone = curDloGen.topo.isDogbone
		self.params.leftTap  = curDloGen.topo.leftTap
		self.params.rightTap  = curDloGen.topo.rightTap
		
		self.construct()
		self.lock()

	def construct(
		self):
		"""
# Fast version of MosContact.construct()
		Build the layout.
			"""
		params = self.params
		curDloGen = DloGen.currentDloGen()
		curDloGenLayer = curDloGen.layer
		lowerLayer = curDloGenLayer.diffusion
		
		rules = curDloGen.rules
		dfmRules = curDloGen.dfmRules

		direction = params.direction
		# Direction multiplier for coordinate expansion
		directionMult = -1 if direction == WEST else 1
		# Create lower layer rect
		pt0 = params.pt0
		x, y = pt0.getX(), pt0.getY()
		lowerBoxWidth = rules.minWidthBulkEncContact
		isDogbone = params.isDogbone
		lowerBoxHeight = params.width if not isDogbone else rules.minWidthDiffEncContact
		lowerBox = Box(x, 0, x+directionMult*lowerBoxWidth, lowerBoxHeight)
		lowerBox.fix()
		
		# TODO actual minArea implementation is 2 grid larger!
		if params.varSpace != rules.contArraySpaLar: # for integ tap different area check 
			#lowerBox.expandForMinArea(direction, rules.diffMinArea, curDloGen.grid)
			lowerBox.expandForMinArea(direction, 0.0555, curDloGen.grid)
		else :
			lowerBox.expandForMinArea(direction, 0.0405, curDloGen.grid) 
		
		if isDogbone:
			lowerBox.setTop(rules.minWidthDiffEncContact)
			gateBox = Box(0,0,0, params.width)
			lowerBox.alignEdge(NORTH_SOUTH, gateBox)
			lowerBox.snapTowards(curDloGen.grid, NORTH)
		self.lowerRect = lowerRect = Rect(lowerLayer, lowerBox)
		self.pinShapes = [lowerRect]
		self.add(lowerRect)

		# Generate metal Contact and cuts
		upperLayer = curDloGenLayer.metal1
		viaLayer = curDloGenLayer.contact
		lowerEnc = rules.bulkExtContact
		lowerEndEnc = rules.diffExtContact
		upperEndEnc = rules.metal1EndExtContact
		

		# Compute viaFillBox
		viaFillBox = Box(lowerBox)
		viaFillBox.expand(NORTH_SOUTH, -lowerEndEnc)
		viaFillBox.expand(EAST_WEST, -lowerEnc)
		# Generate via cuts
		viaWidth  = rules.contactWidth
		#viaSpace  = rules.contactSpace
		viaSpace   = params.varSpace #0.15 changed for XOR 
		
		Rect.fillBBoxWithRects(viaLayer, viaFillBox, viaWidth, viaWidth,
			viaSpace, viaSpace, GapStyle.DISTRIBUTE)
		# Create upper layer rect -- neg 0.005 
		extraMetL = 0.005 if (direction == WEST and viaSpace == rules.contArraySpaLar) else 0 
		extraMetR = 0.005 if (direction == EAST and viaSpace == rules.contArraySpaLar) else 0 
		
		upperBox = Box(lowerBox.getLeft()-extraMetR, viaFillBox.getBottom(), lowerBox.getRight()+extraMetL, viaFillBox.getTop())
		upperBox.expand(NORTH_SOUTH, upperEndEnc)
		self.upperRect = upperRect = Rect(upperLayer, upperBox)
		self.pinShapes.append(upperRect)
		self.add(self.upperRect)

		# Create tapImplant
		tapImplantBox = Box(lowerBox)
		
		if params.integrated:
			tapImplantBox.expand(NORTH_SOUTH, rules.implantExtBulk)
			if not params.flush:
				tapImplantBox.expand(direction, rules.implantExtBulk)
		else:
			tapImplantBox.expand(rules.implantExtBulk)
		if params.integrated and params.flush:
			x1 = tapImplantBox.getLeft()    
			y1 = tapImplantBox.getBottom()
			x2 = tapImplantBox.getRight()
			y2 = tapImplantBox.getTop()
			impWidth = tapImplantBox.getWidth()
			impHeight = tapImplantBox.getHeight()
			if (impHeight*impWidth) < rules.implantMinArea:
				self.grid = Grid( 0.005, snapType=SnapType.CEIL)
				extraImp = self.grid.snap(((rules.implantMinArea/impWidth)-impHeight)*0.5)        
				tapImplantBox.setBottom(y1-extraImp)
				tapImplantBox.setTop(y2+extraImp)
		
		impDrawn = Rect(curDloGenLayer.tapImplant, tapImplantBox)

	####################################################################

	def setPin(
		self,
		pinName,
		termName,
		layers=None):
		"""Create pins for upper layer rectangle.
			"""
		pin   = Pin.find( pinName)
		if not pin:
			pin = Pin( pinName, termName)

		pin.addShape( self.upperRect)

########################################################################

class MosGate3( MosCC):
	"""
#Fast version of MosGate2
Transistor gate poly and underlying channel built using design
rule lookups.
	"""
	####################################################################

	def __init__(
		self,
		diffLayer,
		gateLayer,
		gateWidth,
		gateLength,
		poShrink,
		finger,
		pt0       = None):
		"""Create transistor gate poly and channel diffusion.
			"""
		if not pt0:
			pt0 = Point( *SCRATCHPAD)

		MosCC.__init__(self, locals())
		self.construct()
		self.lock()

	####################################################################

	def construct(
		self):
		"""
#Fast version of MosGate.constructByLookup
Build the layout using rule lookups.
		"""
		# Compute channel diffusion.
		curDloGen = DloGen.currentDloGen()
		rules = curDloGen.rules
		params = self.params
		pt0 = params.pt0
		poShrink = params.poShrink
		dBox  = Box(pt0, pt0 + Point(params.gateLength, params.gateWidth))
		# Do not generate channel diff for efficiency.
		
		# Create channel poly
		gateLayer = params.gateLayer
		endcap = rules.polyExtDiff
		box    = Box(dBox).expand(NORTH, endcap + poShrink[1] + curDloGen.dfmRules.DUpper_PO_EX_INC)
		box.expand(SOUTH, endcap + poShrink[2] + curDloGen.dfmRules.DLower_PO_EX_INC)
		pRect = Rect(params.gateLayer, box)
		self.add(pRect)
		
		boxE = Box(0, 0, params.gateLength, params.gateWidth)   
		
		pRect1 = Rect(params.gateLayer, boxE)
		# Adding Stretch Handle for length, width and gate spacing 
		if params.finger == 0:
				sname = Unique.Name()
				stretchHandle(
						name        = sname,
						shape       = pRect1,
						parameter   = "w",
						location    = Location.UPPER_CENTER,
						direction   = NORTH_SOUTH,
						stretchType = "relative",
						minVal      = 0,
						userSnap    = "%f" % ( 0.005),
				)
						
				stretchHandle(
						name        = sname,
						shape       = pRect,
						parameter   = "l",
						location    = Location.CENTER_RIGHT,
						direction   = EAST_WEST,
						stretchType = "relative",
						minVal      = 0,
						userSnap    = "%f" % ( 0.005),
				)
		elif params.finger == 1:        
				sname = Unique.Name()
				stretchHandle(
						name        = sname,
						shape       = pRect,
						parameter   = "fingers_SP_INC",
						location    = Location.CENTER_CENTER,
						direction   = EAST_WEST,
						stretchType = "relative",
						minVal      = 0,
						userSnap    = "%f" % ( 0.005),
				)
		#pRect1.destroy()
		# Create top and bottom poly rectangles for later use as pins.
		pinPoBox  = Box(box)
		pinPoBox.setTop( dBox.getBottom())
		rect = Rect( gateLayer, pinPoBox)
		self.add( rect)
		self.pinShapes = [rect]

		pinPoBox.set(box)
		pinPoBox.setBottom( dBox.getTop())
		rect = Rect( gateLayer, pinPoBox)
		self.add( rect)
		self.pinShapes.append( rect)

	####################################################################

	def setPin(
		self,
		pinNamePrefix,
		termName,
		layers=None):
		"""Create upper and lower gate pins.  Two different approaches
		since cloned objects will not have pinShapes defined.
			"""
		# Different pins, same terminal => weak connects
		i = 0
		for suffix in ( "_T", "_B"):
			pinName = "%s%s" % ( pinNamePrefix, suffix)
			pin = Pin.find( pinName)
			if not pin:
				pin = Pin( pinName, termName)
			pin.addShape( self.pinShapes[i])
			i += 1

########################################################################
#                                                                      #
# Classes of Transistor Assembly                                       #
#                                                                      #
########################################################################

class MosBody( MosCC):
	"""Parent class for MOS transistor.
		"""

########################################################################

class MosBodyCustom( MosBody):
	"""MOS transistor with contact coverage parameter.
		"""
	#Dan- is this class needed. Using only its superclass will be faster.
	####################################################################

	def __init__(
		self,
		diffLayer,
		gateLayer,
		metal1Layer,
		metal2Layer,
		contactLayer,
		fingers):
		"""Build a stack of MOS transistors.  Options:
		* Connect gates with a poly contact,
		* Connect source/drain contacts.
		* Wire width for connecting source/drain.
		* Source/drain contact coverage.
			"""
		MosBody.__init__(self, locals())
		self.lock()
