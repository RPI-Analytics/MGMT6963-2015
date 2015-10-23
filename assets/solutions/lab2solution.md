Lab 2 Solution.
1. What happens when we mix types in R?
age<-c(20, 15, 13, "ten") 

*You cannot mix numeric variables with text.  The entire vector is treated as text*

2. Can you do math on vectors in R?  Try the following. What happens and why?  [Uses code from above.]
`percent<-(grades/25*100)`
`age<-age+1`
*You can do math on vectors but in the above example, age is treated as a string vector.*


3. Using R, write a set of commands that returns the sum, average, and standard deviation of a vector.

~~~
ages<- c(19,19,12,23)
ages.sum<- sum(ages)
ages.mean<-mean(ages)
ages.sd<-sd(ages)
~~~

4.  Using R, write a set of commands that swaps a set of variables such that A is equal to B and B is equal to A. 

~~~
a<-4
b<-3
c<-a
a<-b
b<-c
~~~

5. Describe the difference between a factor vector and a String vector in R.  

"Factor variables are categorical variables that can be either numeric or string variables. There are a number of advantages to converting categorical variables to factor variables. Perhaps the most important advantage is that they can be used in statistical modeling where they will be implemented correctly, i.e., they will then be assigned the correct number of degrees of freedom." [Source](http://www.ats.ucla.edu/stat/r/modules/factor_variables.htm)

6. Think back to our Titanic dataset.  Could we employ an R matrix for this data?  Why or why not? 

No, because the data was of many different types. 

7. In R, why is it relevant to set the working directory?  On the virtual machine, what directory corresponds with the course repository? 

*Setting the working directory provides a location of the files.  This is where R will look for a file. Files between the guest and the host will be shared at `/vagrant`.*

8. Specify the R code to do each of the following: (a.) a random number between 1 and 8.  (b.) a random integer between 1 and 10. (c.) a random set of 2 integers 1-10 that are not the same, (d.) a random number from a distribution with  a mean of 4 and a standard deviation of 2. 
**Hint: [This guide](http://blog.revolutionanalytics.com/2009/02/how-to-choose-a-random-number-in-r.html)  and [this guide](http://www.cookbook-r.com/Numbers/Generating_random_numbers/)can provide a nice overview.

~~~
# A. A random number between 1 and 8. 
x1 <- runif(1, 1, 8)
x1 

# B. A random integer between 1 and 10.
 x2 <- sample(1:10, 1)
 x2
 
 # C. A random set of 2 integers 1-10 that are not the same
x3 <- sample(1:10, 2, replace=F)
x3

# D. A random number from a distribution with  a mean of 4 and a standard deviation of 2. 
x4 <- rnorm(5, mean=4, sd=2)
x4

~~~


9. What does it mean to sample random numbers "with replacement" vs. without replacement. 

*With replacement means random numbers can repeat. Without replacement means that the random numbers cannot repeat.*

10. Is there a difference between the data stored via the alldata and the alldata2 array in the above Python example?  Why?     

*No difference between the two arrays.*

11. Is there a difference with the somedata versions of ages/grades and the all data version of ages/grades in the Python example?

*Yes - because all data in a numpy array has to be of a single type, the alldata version of ages/grades are characters because namesNP, femaleNP, and teachersNP are character/string.  The somedata version of ages/grades are numeric/integer type (no single quotes).*

12. Create a function in R that accepts 2 value (n, m) and returns an N x M matrix with random numbers with a mean of 20 and a standard deviation of 5.  

~~~
n <- sample(1:9, 1)
m <- sample(1:9, 1)
test1 <- function(n,m) {matrix(rnorm(n*m, mean=20, sd=5), nrow=n, ncol=m)}
test1(n,m)

13. Write Python code to set a variable  n equal to 144 and then take the square route of n.  

~~~
import math
	n = 144
	math.sqrt(n)
	
~~~


14. Using Python, write a set of commands that swaps a set of variables such that A is equal to B and B is equal to A. [For example, let's say A = 5 and B = 6 at the beginning.  After entering your commands  A must be equal to 6 and B must be equal to 5.]

~~~
var1 = 2
	var2 = 4
	var1 = var1 + var2
	var2 = var1 - var2
	var1 = var1 - var2
	print var1
	print var2
~~~

15. Describe how the subsetting of arrays works differently in Python than R.  For example, how would grades[2] and grades[3:4] work differently in R and Python.

~~~
With grades = [20, 15, 13, 19)
	in R - grades[2] returns the 2nd value (15) in the array
	in Python - grades[2] returns the 3rd value (13) in the array
	**because Python indexing starts at 0 and R indexing starts at 1
	in R - grades[3:4] returns (13, 19)
	in Python - grades [3:4] returns (19)
	**because a subset in Python does not include the final element in the slice (i.e. the “4” in 3:4)
~~~
	


16. Create a function which returns an array of 2 different strings from a character array.  *[Hint.](https://docs.python.org/2/library/random.html)*   *If given, a character array such as names, where....names=["Sally", "Jason", "Bob", "Susy"]  The function should (randomly) return 2 of the names. For example, ['Sally', 'Susy'].*

~~~
test1 = ["red","orange","yellow","green","blue","indigo","violet"]
	def split():
    		return [random.choice(test1), random.choice(test1), random.choice(test1)], [random.choice(test1), random.choice(test1), random.choice(test1)]
	arr1, arr2 = split()
	print arr1
	print arr2
~~~

17. Find a different CSV from the classroom discussion and upload it to a Pandas.  Was the data processed correctly?
