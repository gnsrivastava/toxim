#!/opt/lampp/htdocs/anaconda2/envs/my-rdkit-env/bin/python
from rdkit import Chem
from rdkit.Chem import AllChem
from rdkit.Chem import Descriptors
from rdkit.ML.Descriptors import MoleculeDescriptors
nms=[x[0] for x in Descriptors._descList]
calc = MoleculeDescriptors.MolecularDescriptorCalculator(nms)
suppl = Chem.SDMolSupplier("file")
des = []
for m in suppl:
   if m is None: continue 
   des.append(calc.CalcDescriptors(m))
   f = open('desc.txt', "a")
   X = calc.CalcDescriptors(m)
   f.write( str(X) + "\n"  )
   f.close ()
