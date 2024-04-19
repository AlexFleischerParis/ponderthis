

"""
efficient prime test from internet
"""

from math import sqrt

def primes(n):
    r = [True] * n
    r[0] = r[1] = False
    r[4::2] = [False] * len(r[4::2])
    for i in range(int(1 + sqrt(n))):
        if r[i]:
            r[3*i::2*i] = [False] * len(r[3*i::2*i])
    return r

big=1000000000
P=primes(big)

def is_prime(v):
    return P[v]



"""
In watsonx mixtral we use the prompt

write a python function to test whether a parameter n and a list A
for all j in A we have (i+j) that is not a prime number

which gives

"""

def not_prime_sum(n, A):
    for j in A:
        if (n + j) > 1 and is_prime(n + j) == True:
            return False
    return True
    
"""

in watsonx mixtral we use the prompt

write a python function with parameter N  that
builds a list with N elements so that
a[0] is 0 and then for all i between 0 and N, a[i] is i+a[i-1]

"""

def build_list(N):
    a = [0]
    for i in range(1, N):
        a.append(i + a[i-1])
    return a

"""
as a programmer we have to write the following code
in order to find the smallest value that is ok
"""

N=1000

A=build_list(N)
for i in range(1,big):
  if (not_prime_sum(i,A)):
      print(i)
      break

"""
gives
115192665
"""

