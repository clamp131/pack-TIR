import pysam,numpy as np,scipy as sp
from Bio import SeqIO,Restriction
import os
import commands
import multiprocessing as mp
site1=[i.strip().split() for i in open("/rd/mahj/HIC/script/Drosophila.chromsize")]
site={k:[] for k in set([i[0] for i in site1])}
for i in site1:
  site[i[0]].append(int(i[1]))
pos_read=[i.strip().split() for i in open("/rd/mahj/HIC/GSE100370/4K/interposition")]
pos={k:[] for k in set([i[0] for i in pos_read])}
for i in pos_read:
  pos[i[0]].append([int(i[1]),int(i[2])])
#pos.pop('chr3L')

def get_pre(s):
  sam=pysam.AlignmentFile("%s"%s)
  rd={}
  for r in sam.fetch(until_eof=True):
    v=(r.reference_name,r.is_reverse,r.reference_start if not r.is_reverse else r.reference_end)
    if not r.query_name in rd:
      if r.is_read1:
        rd[r.query_name]=[v,None]
      else:
        rd[r.query_name]=[None,v]
    else:
        if r.is_read1:
          rd[r.query_name][0]=v
        else:
          rd[r.query_name][1]=v
  rd=[v for v in rd.itervalues() if not any ([k is None for  k in v])]
  rd=[v for v in rd if v[0][0]!=v[1][0]]
  print len(rd)
  fout=open("%s"%s+".pre-inter",'w')
  for i in rd:
    print >> fout, int(bool(i[0][1])),i[0][0],i[0][2],'0',int(bool(i[1][1])),i[1][0],i[1][2],'1'
  fout.close()
  print "%s.pre-inter has done!!"%s

def get_hic(s):
  log=[]
  log.append(commands.getstatusoutput("awk 'BEGIN{OFS=\"\t\"}{if($2>$6){print $5,$6,$7,$8,$1,$2,$3,$4}else{print$1,$2,$3,$4,$5,$6,$7,$8}}' %s.pre-inter >%s.pre-inter.tmp"%(s,s)))
  log.append(commands.getstatusoutput("sort -k2,2d -k6,6d %s.pre-inter.tmp >%s.pre-inter.sort"%(s,s)))
  log.append(commands.getstatusoutput("java -jar /home/mahj/program/bin/juicer_tools.1.8.9_jcuda.0.8.jar pre "+"%s"%s+".pre-inter.sort "+"%s"%s+"-inter.hic"+" /rd/mahj/HIC/script/Drosophila.chromsize"))
  print log
  print "%s.inter.hic has done!!"%s
  return log

def for_dump(s):
  log=[]
  f=open("inter-out.std",'a')
  for k,v in pos.items():
    for i in v:
      log.append(commands.getstatusoutput("java -jar /home/mahj/program/bin/juicer_tools.1.8.9_jcuda.0.8.jar dump observed NONE %s-inter.hic 3L:20148499:20238499 %s:%s:%s BP 10000 %s.dump-tmp"%(s,k,i[0]-40000,i[0]+50000,s)))
      print log[0][1]
      qq=[n.strip().split() for n in open("%s"%s+".dump-tmp")]
      qq=[[int(n[0]),int(n[1]),float(n[2])] for n in qq]
      cm=sp.zeros([9,9],dtype=float)
      print i
      print qq
      for n in qq:
        print 'n0',n[0],'site3L',site['3L'][0],'i0',i[0],'n1',n[1],'n2',n[2]
        cm[(n[0]-20148499)/10000,(n[1]-(i[0]+i[1])/2-40000)/10000]+=n[2]
      print cm
    #  for i in v:
     #   m=(i[0]+i[1])/2
#        tmp=cm[20188499/10000-5:20188499/10000+6,m/10000-5:m/10000+6]
      tmp1=list(cm.flatten())
      a=tmp1[50]
      del tmp1[50]
      tmp2=a-2*sp.std(tmp1)-sp.mean(tmp1)
      print 'chrom',k,'middle',a,'std',2*sp.std(tmp1),'mean',sp.mean(tmp1)
      print >>f,s,k,i[0],i[1],tmp2,a,sp.mean(tmp1),2*sp.std(tmp1)
      print k,i[0],i[1],tmp2

def onebyone():
  x=[i for i in os.listdir('.') if i[-3:]=='sam']
  for j in x:
    print j
    get_pre(j)
    get_hic(j)
    for_dump(j)

onebyone()
