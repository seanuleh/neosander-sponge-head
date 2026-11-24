import sys, re, struct, xml.etree.ElementTree as ET
src, dst = sys.argv[1], sys.argv[2]
ns={'m':'http://schemas.microsoft.com/3dmanufacturing/core/2015/02'}
t=ET.parse(src); r=t.getroot()
V=[];T=[]
for obj in r.iter('{%s}object'%ns['m']):
    m=obj.find('m:mesh',ns)
    if m is None: continue
    off=len(V)
    V+= [(float(v.get('x')),float(v.get('y')),float(v.get('z'))) for v in m.find('m:vertices',ns)]
    T+= [(int(x.get('v1'))+off,int(x.get('v2'))+off,int(x.get('v3'))+off) for x in m.find('m:triangles',ns)]
with open(dst,'wb') as f:
    f.write(b'\0'*80+struct.pack('<I',len(T)))
    for a,b,c in T:
        f.write(struct.pack('<3f',0,0,0))
        for i in (a,b,c): f.write(struct.pack('<3f',*V[i]))
        f.write(b'\0\0')
xs,ys,zs=zip(*V)
print(dst, len(V), len(T), 'X',round(min(xs),2),round(max(xs),2),'Y',round(min(ys),2),round(max(ys),2),'Z',round(min(zs),2),round(max(zs),2))
