import pandas as pd
import sys

scdbl_path = sys.argv[1]
out = sys.argv[2]

select = 'scDblFinder_DropletType'

scdbl = pd.read_csv(scdbl_path, sep='\t', header=0,index_col=0)

mask = scdbl[select] == 'doublet'

pd.DataFrame(index=scdbl[~mask].index).to_csv(out, sep='\t', header=False, index=True)
