# Assisted by watsonx Code Assistant 
# write a python function with parameter d and n that returns true 
# if and only if digit d is in the number n
def is_digit_in_number(d, n):
    return str(n).count(str(d)) > 0

    
 
 # Assisted by watsonx Code Assistant 
 # write a python function with parameter d and N which does a loop 
 # on i between 1 and N which contains a counter c that 
 # will be incremented if is_digit_in_number(d,i) is true and if c is exactly 
 # half of i then i is added to a list l that will be returned by the function
def find_values_i(d, N):
    l = []
    c = 0
    for i in range(1, N+1):
        if is_digit_in_number(d, i):
            c += 1
        if c == i/2:
            l.append(i)
    return l

# Assisted by watsonx Code Assistant 
# write a python function that does a loop 
# for all d from 1 to 9 included which will 
# for each d get the maximum value ma in the
#  list returned by find_values_i(d,1000000000) 
# and display for digit d we get this value ma   
  
 
def find_max_value_for_digits():
    for d in range(1, 10):
        ma = max(find_values_i(d, 1000000000))
        print(f'For digit {d}, we get this value ma: {ma}')

find_max_value_for_digits()

"""
which gives
For digit 1, we get this value ma: 1062880
For digit 2, we get this value ma: 2125762
For digit 3, we get this value ma: 3188644
For digit 4, we get this value ma: 4251526
For digit 5, we get this value ma: 5314408
For digit 6, we get this value ma: 6377290
For digit 7, we get this value ma: 17006110
For digit 8, we get this value ma: 18068992
For digit 9, we get this value ma: 19131874
"""