#! /usr/bin/env python3

"""
python $this_script water phobe [output]

This script calculates the LJ potentials between various water and
various hydrophobes.

The water properties are stored in dictionaries with the usual names 
of the water models in lowercase as keys: spc, spce, and tip3p. 
The water properties that vary are the bond lengths, charges,
and Lennard-Jones parameters. Note that the Lennard-Jones parameters
are stored in the units used by Paschek (Å and K). 

The hydrophobe is just a Lennard-Jones particle. Again, the parameters 
are in the units used by Paschek (Å and K). 

The Lennard-Jones parameters are converted into the soft-sphere diameter
and electronic dispersion strength C6, both in atomic units.

@ss12ww
@ss12wh
@ss12hh
@c6ww
@c6wh
@c6hh

NB: This is a Python 3 script!

Gus GW, gusgw@gusgw.net, 30/8/2012.
Mao L, chairman@mao.id.au, 03/05/2013
"""

import sys
import os
import glob

# Functions that convert back and forth between the 
# parameters used by toymd and the usual Lennard-Jones
# definitions.

# A function to calculate the soft-sphere diameter.
def getss(eps,sig):
  return 1.122462048309373*(3.16693e-6*eps)**(1.0/12.0)*(sig/0.529)

# A function to calculate c6.
def getc6(eps,sig):
  return 4.0*(3.16693e-6*eps)*(sig/0.529)**6

# A function to calculate the L-J sigma.
def getsig(ss,c6):
  return (ss**2/c6**(1.0/6.0))*0.529

# A function to calculate the L-J epsilon.
def geteps(ss,c6):
  return ((0.25*c6**2)/ss**12)/3.16693e-6

# Store the soft-sphere diameter and dispersion strength
# for the three 3-site waters that we're using. These 
# parameters are the ones taken as inputs to toymd.
ss12ww =   {'spc':3.3623,   'spce':3.3623,   'tip3p':3.34058}
c6ww =     {'spc':45.4697, 'spce':45.4697, 'tip3p':43.275}

# Store the hydrophobe Lennard-Jones parameters in the units 
# given by Paschek. The LJ diameters are in Å and
# and the well depths are in K.
ljsighh =   {"Ne":3.035,   "Ar":3.415,  "Kr":3.675,  "Xe":3.975,  "CH4":3.730}
ljepshh =   {"Ne":18.6,   "Ar":125.0,  "Kr":169.0,  "Xe":214.7,  "CH4":147.5}

# Set up a list of temperatures as well.
setTvalues = {}
for TinK in range(260,376,5):
  setTvalues[str(TinK)+"K"] = (TinK/298.0)*0.00094374486
setTvalues["298K"] = 0.00094374486

# Define functions that will calculate the soft-sphere diameter
# and C6 strength used by toymd from the Lennard-Jones parameters
# given by Paschek.

def getss12hh(phobe):
  return str(getss(ljepshh[phobe],ljsighh[phobe]))
def getc6hh(phobe):
  return str(getc6(ljepshh[phobe],ljsighh[phobe]))

def getss12ww(model):
  return str(ss12ww[model])
  
def getc6ww(model):
  return str(c6ww[model])

def getss12wh(model,phobe):
  # To combine the parameters we need them in the normal LJ units.
  epsww = geteps(ss12ww[model],c6ww[model])
  sigww = getsig(ss12ww[model],c6ww[model])
  # Use the LB rules.
  epswh = (epsww*ljepshh[phobe])**0.5
  sigwh = (sigww+ljsighh[phobe])*0.5
  # Convert back the toymd units.
  return str(getss(epswh,sigwh))

def getc6wh(model,phobe):
  # To combine the parameters we need them in the normal LJ units.
  epsww = geteps(ss12ww[model],c6ww[model])
  sigww = getsig(ss12ww[model],c6ww[model])
  # Use the LB rules.
  epswh = (epsww*ljepshh[phobe])**0.5
  sigwh = (sigww+ljsighh[phobe])*0.5
  # Convert back the toymd units.
  return str(getc6(epswh,sigwh))

def get_lj(watermodel,hydrophobe):
  # Set up the replacements that we're going to do.
  rules = {}
  rules["@ss12ww"] = getss12ww(watermodel)
  rules["@ss12wh"] = getss12wh(watermodel,hydrophobe)
  rules["@ss12hh"] = getss12hh(hydrophobe)
  rules["@c6ww"] = getc6ww(watermodel)
  rules["@c6wh"] = getc6wh(watermodel,hydrophobe)
  rules["@c6hh"] = getc6hh(hydrophobe)
  return rules

if not(sys.argv[1] in ss12ww.keys()):
  print("Invalid water specifier")
  print("Accepted specifiers: "+",".join(ss12ww.keys()))
  exit(1)
  
if not(sys.argv[2] in ljsighh.keys()):
  print("Invalid hydrophobe specifier")
  print("Accepted specifiers: "+",".join(ljsighh.keys()))
  exit(1)

rules=get_lj(sys.argv[1],sys.argv[2])
outstr=""
if len(sys.argv)>3:
  for flag in sys.argv[3:]:
    if not(flag) in rules.keys():
      print("Invalid output specifier: "+flag)
      print("Accepted output specifiers: "+",".join(rules.keys()))
    else:
      outstr=outstr+rules[flag]+"\t"
  print(outstr)
else:
  print(rules)
