mport pysam,numpy as np,scipy as sp
from Bio import SeqIO,Restriction
import os
import commands
import multiprocessing as mp
fa={i.id:i.seq for i in SeqIO.parse(open("/rd/mahj/HIC/genome/dmel-all-chromosome-r6.21.fasta"),'fasta')}

def get_pre(s):
  digenome={k:Restriction.MboI.search(v) for k,v in fa.iteritems()}
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
  rd=[v for v in rd if v[0][0]==v[1][0]]
  rs={k:[] for k in set([v[0][0] for v in rd])}
  for k in rd:
    rs[k[0][0]].append(k)
  rs.keys()
  for k,v in digenome.iteritems():
    digenome[k].append(len(fa[k]))
  rt={k:[None,None,None,None,None,None] for k in set([v for v in rs.keys()])}
  for key,value in rs.iteritems():
    r1=[v[0][2] for v in value]
    r2=[v[1][2] for v in value]
    rt[key][0]=sp.searchsorted(digenome[key],r1)
    rt[key][1]=sp.searchsorted(digenome[key],r2)
    rt[key][2]=[v[0][1] for v in value]
    rt[key][3]=[v[1][1] for v in value]
    rt[key][4]=r1
    rt[key][5]=r2
  for key in rt.keys():
    flag=sp.array([k[0][1] for k in rs[key]],dtype=bool)
    rt[key][0]=rt[key][0]*(1-flag)+(rt[key][0]-1)*flag
    flag=sp.array([k[1][1] for k in rs[key]],dtype=bool)
    rt[key][1]=rt[key][1]*(1-flag)+(rt[key][1]-1)*flag
  digenome={k:sp.array(v) for k,v in digenome.iteritems()}
  rt1={k:[None,None] for k in set([v for v in rt.keys()])}
  for key in rt.keys():
    rt1[key][0]=digenome[key][rt[key][0]]
    rt1[key][1]=digenome[key][rt[key][1]]
  rflag={k:[] for k in rt.keys()}
  for key in rt.keys():
    r1=sp.array([v[0][2] for v in rs[key]])
    r2=sp.array([v[1][2] for v in rs[key]])
    p1=abs(r1-rt1[key][0])<500
    p2=abs(r2-rt1[key][1])<500
    rflag[key]=p1*p2
  rq={k:[None,None,None,None,None,None] for k in set([v for v in rs.keys()])}
  x={k:sp.array(v) for k,v in rt.iteritems()}
  for k in rt.keys():
    rq[k][0]=x[k][0][rflag[k]]
    rq[k][1]=x[k][1][rflag[k]]
    rq[k][2]=x[k][2][rflag[k]]
    rq[k][3]=x[k][3][rflag[k]]
    rq[k][4]=x[k][4][rflag[k]]
    rq[k][5]=x[k][5][rflag[k]]
  rqt={k:sp.array(v).T for k,v in rq.iteritems()}
  fout=open("%s"%s+".pre",'w')
  for k,v in rqt.iteritems():
    for i in v :
      print >> fout, i[2],k,i[4],i[0],i[3],k,i[5],i[1]
  fout.close()

def get_hic(s):
  log=[]
  log.append(commands.getstatusoutput("java -jar /home/mahj/program/bin/juicer_tools.1.8.9_jcuda.0.8.jar pre "+"%s"%s+".pre "+"%s"%s+".hic"+" /rd/mahj/HIC/script/Drosophila.chromsize"))
  return log

def for_dump(s):
  log=[]
  log.append(commands.getstatusoutput("java -jar /home/mahj/program/bin/juicer_tools.1.8.9_jcuda.0.8.jar dump observed VC %s"%s+".hic"+" chr3L chr3L BP 10000 %s"%s+".dump"))
  return log

def for_std(s):
  qq=[i.strip().split() for i in open("%s"%s+".dump")]
  qq=[[int(i[0]),int(i[1]),float(i[2])] for i in qq]
  position=[i.strip().split() for i in open('innerposition')]
  print position
  position=[[i[0],i[1],i[2],int(i[3]),int(i[4])] for i in position]
  print i
  cm=sp.zeros([28110227/10000+1,28110227/10000+1],dtype=float)
  for i in qq:
    cm[i[0]/10000,i[1]/10000]+=i[2]
#  f=open("tmp-out.std",'a')
    f=open("inner.std",'a')
#  f1=open("dividedposition",'a')
  for i in position:
    m=(i[3]+i[4])
    tmp=cm[20187371/10000-4:20187371/10000+5,m/20000-4:m/20000+5]
    tmp1=list(tmp.flatten())
    del tmp1[60]
    tmp2=cm[20187371/10000,m/20000]-2*sp.std(tmp1)-sp.mean(tmp1)
    print >>f, s,i[0],i[1],i[2],i[3],i[4],tmp2,cm[20187371/10000,m/20000],sp.mean(tmp1),2*sp.std(tmp1)
  f.close()
#    else:
 #     print >>f1,i[0],i[1],i[2],i[3],i[4]
#  tmp=cm[20187371/10000-5:20187371/10000+6,6862289/10000-5:6862289/10000+6]
 # tmp1=tmp.flatten()
  #tmp2=cm[20187371/10000,6862289/10000]-2*sp.std(tmp1-cm[20187371/10000,6862289/10000])-sp.mean(tmp1-cm[20187371/10000,6862289/10000])
  #print >>f, "white&position2",tmp2
#  f.close()
#  f1.close()

def shell3():
  x=[i for i in os.listdir('.') if i[-3:]=='sam']
  print x
  p=mp.Pool(3)
  y=p.map(get_pre,x)
  p.close()
  p.join()
  return y

def shell4():
  x=[i for i in os.listdir('.') if i[-3:]=='sam']
  print x
  p=mp.Pool(3)
  y=p.map(get_hic,x)
  p.close()
  p.join()
  return y

def shell5():
  x=[i for i in os.listdir('.') if i[-3:]=='sam']
  print x
  p=mp.Pool(3)
  y=p.map(for_dump,x)
  p.close()
  p.join()
  return y

def shell6():
  x=[i for i in os.listdir('.') if i[-3:]=='sam']
  print x
  p=mp.Pool(2)
  y=p.map(for_std,x)
  p.close()
  p.join()
  return y

def shell7():
  x=[i for i in os.listdir('.') if i[-3:]=='sam']
  print x
  for i in x:
    for_std(i)

#shell3()
#shell4()
shell5()
shell6()
