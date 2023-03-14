'''

In probability theory, the birthday problem asks for the probability that, 
in a set of n randomly chosen people, at least two will share a birthday. 
The birthday paradox refers to the counterintuitive fact that only 23 people 
are needed for that probability to exceed 50%. (Wikipedia)

https://en.wikipedia.org/wiki/Birthday_problem

Let's compute this probability with Monte Carlo in python

'''

from random import randint
import time

start = time.time()



nbDays=366
nbBirthdays=23
n=1000000

birthdays=[[0 for i in range(0,nbBirthdays)] for j in range(0,n)]
nbtwicesamebirthday=0

for i in range(0,n):
    for j in range(0,nbBirthdays):
        birthdays[i][j]=randint(0,nbDays)
for i in range(0,n):        
    if (len(set(birthdays[i])))!=nbBirthdays:
        nbtwicesamebirthday=nbtwicesamebirthday+1
      
print("probability : ",nbtwicesamebirthday/n)

end = time.time()
print("time        : ",end - start)

'''

which gives

probability :  0.505954
time        :  15.789838552474976

'''

        
    

