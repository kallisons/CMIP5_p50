#ipython --pylab
import scipy
from mpl_toolkits.basemap import Basemap, addcyclic, shiftgrid
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab

Folder = '/Data/Projects/CMIP5_p50/ipsl/'
species1 = ['Thunnus_obesus', 'Thunnus_albacares', 'Katsuwonus_pelamis', 'Thunnus_thynnus', 'Scomber_japonicus', 'Thunnus_maccoyii']

#leftlist = [0.02, 0.216, 0.412, 0.608, 0.804]
leftlist = [0.02, 0.24, 0.48, 0.72]
#bottomlist = [0.755, 0.51, 0.265, 0.02]
#bottomlist = [0.7525, 0.505, 0.2575, 0.01]
bottomlist = [0.76, 0.52, 0.27, 0.02]

width = 0.42
#height = 0.225
height = 0.23
#height = 0.20

g = [[0.06, bottomlist[0], width, height], [0.56, bottomlist[0], width, height],
     [0.06, bottomlist[1], width, height], [0.56, bottomlist[1], width, height],
[0.06, bottomlist[2], width, height], [0.56, bottomlist[2], width, height],
[0.06, bottomlist[3], width, height], [0.56, bottomlist[3], width, height]]

i = 0
while i<len(species1):
  file = Folder + '/' + species1[i] + '/deltap50depth/ipsl.deltap50depthav.' + species1[i] + '.nc'
  nc = Dataset(file,'r')
  lats = nc.variables['LAT'][:]
  lons = nc.variables['LON'][:]
  lons2 = lons+360
  depth = nc.variables['DELTAP50DEPTHAV'][:]
  depth = depth.squeeze()
  fig = plt.figure(1, figsize(8,10))
  axg1 = plt.axes(g[i])
  m = Basemap(llcrnrlat=-80.,urcrnrlat=80.,projection='cyl',lon_0=200)
  depth_cyclic, lons_cyclic = addcyclic(depth[:,:], lons)
  depth_cyclic, lons_cyclic = shiftgrid(20., depth_cyclic, lons_cyclic, start=True)
  x, y = m(*np.meshgrid(lons_cyclic, lats))
  m.drawmapboundary(fill_color='0.7') #fill_color='0.5'
  m.drawcoastlines()
  m.fillcontinents(color='black', lake_color='0.5')
  if (i == 0) or (i == 2) or (i == 4) or (i == 6):
    m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
  else:
    m.drawparallels(np.arange(-90.,120.,30.),labels=[0,0,0,0])
  m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,0])
  im1 = m.pcolor(x,y,depth_cyclic,cmap=plt.cm.BrBG, vmin=-200, vmax=200)
  cb = m.colorbar(im1,"bottom", size="5%", pad="2%")
  cb.set_ticks([-200,-100,0,100,200])
  cb.set_ticklabels([-200,-100,0,100,200])
  plt.title(species1[i], fontsize=12)
  plt.suptitle("IPSL P50 Depth Change")
  i=i+1

plt.show()

outfig = '/Users/kasmith/Code/Projects/CMIP5_p50/graphs/ipsl_deltap50depthav.ps'
plt.savefig(outfig, dpi=72, bbox_inches=0)