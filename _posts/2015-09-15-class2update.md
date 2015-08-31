
### Presentation
<iframe src="https://docs.google.com/presentation/d/1blf7JLF6EaWnXrw68HAD2STceeDdUVMX16Hkv099sKE/embed?start=true&loop=false&delayms=3000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

### Getting Started with Data
The capacity for our society to generate, manage, and use data is incredible.  Data lays at the foundation of any analytics based process.  Without the ability to effectively assess, manage, and interact with data there is little we will be able to do from an analytics perspective. 

### THE CRISP PROCESS MODEL
![title]({{ site.baseurl }}/img/1_crisp.png)
 
Data is the foundation of all analytics processes, but our thinking of how to store and organize data has shift with technology and with the amount of data required to store and analyze.


#Data Sources
However the data may be analy

##JSON
When storing data, it often is necessary to adopt different paradigms past the matrix in order to meet the needs of the application involving the data. Past the matrix, JSON is the next most common form of data you are likely to find.  JSON has the advantage that they can be hierarchal and have data with complex relationships.   Even when an object is a matrix it is still an object.  

When data has to be transmitted between servers, JSON or JavaScript Object Notation has become the default method for the web.  JSON translater are available for any programming language and can easily input the associated structure into memory. 
```
{
  "firstName": "Jane",
  "lastName": "Doe",
  "address": {
    "streetAddress": "1 North Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021"
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "555-111-2222"
    },
    {
      "type": "mobile",
      "number": "555-121-1212"
    }
  ],
}

For example the flexible structure above allows the associated objects to have complex nested relationships which are difficult to incorporate into traditional matrices.  


## Flat Files
Files are an extremely common way of interacting with datasets, with comma files being the most common.  Delimited files have the structure of a matrix, with columns and rows.  Data within each row is separated by the delimiter.  The delimiter serves to separate the variables and give it structure.  When organized like the example below the data can be easily be opened by programs like Excel or a Google spreadsheet. 

##Relational Databases
The most frequent paradigm in IT related system is the relational database.  Databases have enabled the robust organizational and web systems that the cohesive flow of products and services in our society.  Modeling the data within these systems is typically complex, and database management systems (DBMS) have within them structured tables and *structured query language* (SQL) to connect with the tables. These tables individually are matrixes are connected by keys in such a way that they can incorporate the complex nested relationships of objects.

The relational database provides application designers with a way of ensuring consistency while minimizing redundancy. It accomplishes this by separating the data into different tables. 

Consider the following example. A customer order is likely to contain multiple different products. Each of these products are similarly likely to have inventory, prior shipments, reviews, etc. In order to minimize the redundancy, many product details are included in a product table and then just linked to other tables through the productID key. This productID key provides think link to show. That way, if there is a change in the name of the product, all applications showing different parts of the workflow would be instantly updated.

[diagram]

It also means that as data scientists looking to do an analysis of products frequently purchased together one would first have to connect data from a variety of tables. This isn't that bad really and we will cover it in more detail in the section on relational databases.


##Document oriented databases
This process of separating data into a wide variety of differ tables has a number of problems, however. First of all it doesn't fit very closely with the object oriented model of programming that has grown to dominate the creation of applications. While something called object relational mappers make this process nearly automatic, there is still some complexity in this translation.

In addition, it turns out that as data scales the process of connecting tables through keys becomes a much more time consuming process. As a result, having the capability to store related information in a single place, even if it involves some redundancy, can be a reasonable tradeoff for application developers. In particular, MongoDB has emerged in the past X years as a real competitor when storing a wide variety of data meant to be presented in web based applications. Rather than linked tables, data is stored in objects which may have a reasonably complex internal hierarchy.

##APIs

APIs, or application programming interfaces, are the glue that holds the worlds web applications together. In many cases, API function much like document based databases--providing detailed json.

##Big (Often Unstructured) Data

Big data has been all of the rage in many technology circles, and there are clearly many different context in which the processes and tools developed as part of big data are likely to apply.

The majority of big data related efforts are likely focused around Hadoop, so it is useful to understand what it is that Hadoop does and how it fits into the data science ecosystem. Hadoop was birthed at Yahoo, an open source implementation of the Map Reduce algorithm originally developed by Google. At it core, Hadoop was generated for the web--highly unstructured data that had to be processed. Much of the outcome of Hadoop will be recompiled for future use.

##Data and R/Python
When using data inside of R or Python, data can be of a wide variety of types and whatever the source of the data it can likely mapped to a .  At its core though all data are *objects* and thus their behavior is governed by their underlying classes.  The type and characteristics of the objects are often specifically stated or they can be adopted by defaults (particularly in the case of R).  A lot of the advantages of R come from the fact that it customizes the environment for doing staticstics by default, embedding specific functions, object types, etc. to be 

  These specific characteristics of how data is handled within the programming environment are unique to the languages, meaning that Python, R, and SAS could (and in sometimes do) handle things differently.  It also means that people can implement specific data structures to manage data.  What we will be doing thought is giving you the basics of how to do each.  

##Getting Started with R
R has emerged as among the most popular development environments for analytics.  It has the advantage of being open source and free, has a great community, and it has a tremendous number of packages.  As R is essentially a coding language specific to statistics, it has functional to do just about anything that you want to do.  

Developing with R has made tremendous progress over a short period of time thanks to the developers at RStudio.  RStudio is an Integrated Development Environment (IDE) for R that provides developers with an easy way to manage the development process.  
Log onto the RStudio Sever (Virtual machine needs to be running) using the following.
[http://localhost:8787](http://localhost:8787) 
*Username:* vagrant
*Password:* vagrant

Once you log in you will be presented with the IDE console that has everything that you need to get started with data science.  
![title]({{ site.baseurl }}/img/3_console.png)

When you launch RStudio Server, you immediately see view above.  The R console provides a number of tools that can make data science quick and easy.

On the left side you can see the R console.  The R console directly interprets R code and provides answers.  Try it out by doing some basic math.  
```{r}
3+3
20/4
20^2
```
Now assign the output of a calculation to a new variable. 
```{r}
n<-3+3
```
Notice that as you entered the variable into the R console, it showed up just to the top right of the screen.  This provides a list of the objects available in memory.  Just type `n` into the console again and get access to the variable and print it out.  

*Tip. Want to resubmit or slightly change a previous entry into the console?  Just press up and then down in order to scroll through previous entries.*  

###Programs (Scripts) in R
While the console may allow you to quickly iterate and test commands, most times you are going to want to develop complex combinations of commands that can enable the transformation and analysis of data.  Anything thing entered into the console is not *persistant*, meaning it is not saved past the initial session.  As a result, we recommend working from a script.  In reality, you can think of a script as a program that you are developing to complete some type of process. Start a new script now by File -> New File -> R Script. 
Copy the earlier commands and add it directly to the script.  You can then add comments to the script and save it for future use with the save button.  
![Scripts]({{ site.baseurl }}/img/3_console.png)
There are three different ways to execute the script.  
* The most common mode of operation is to highlight the code that you would like to execute and then press the *execute* (Run current line or selection).  You can also do this using the shortcut key specific for Mac (command-Enter) or Windows (?).
* After running a selection, you may find that you need to make an edit and rerun the same selection.  The thoughtful individuals at RStudio have made this easy. Through the second execute button (Re-run the previous code region). 
* Finally, to execute the entire file, you can execute the source button (with echo to see it in the console). 

### Using and defining functions in R
R has a wide array of functions that are predefined and can be used in the console.  Before we look at R functions, let's define are own so we understand how they work.  

Let's say we want a function that is ready to add 2 numbers. First we have to *define the function*. 
```{r}
#This defines a function called "addTwo."
addTwo <- function(a, b){
c<-a+b
return(c)
}
```
By selecting this function and running it, we can now have access to the function in memory for the rest of this R session.  If we open the script again we would again have to go through the process of loading the function into memory. 

We can then go through the process of utilizing the function by calling it and then specifying the two associated parameters *a & b*. 
```{r}
addTwoNumbers(4, 5)
}
```
*Note that the function specification and use is case sensitive.  The use of descriptive functions with all words except the first capitalized in known as [camel case](https://en.wikipedia.org/wiki/CamelCase).*

Organizing processing of data into functions is quite convenient and facilitates what is one of the holy grails of programming: *code reuse*.  By organizing processing of data into functions, you can easily process data for different datasets or subsets of the data without rewriting the steps for each. 

There are lots of [built in functions](http://www.statmethods.net/management/functions.html)  in R that can provide important functionality. Run the following and see:
```{r}
x<-abs(-20)
textfield<-toupper("this is a lowercase sentence")
```
To understand each function, we can use the embedded help function `help(abs)` to find out about the *absolute value* function and `help(toupper)` to find out about the *to uppercase* function.

## Vector
A single set of values in a particular order.  Even variables that we have set are really just vectors of length 1. 

We can create a vector using the concatenate function `help(c)` for more. Let's say we want a vector with the ages for 4 students.

```{r}
ages<-c(18,19,18,23)
```

To see  this we can just type the name of object:
```{r}
ages
```

To pick a specific value, we can, indicate it. Note. In some languages vectors will start at 0 while in R it will start with 1. 

```{r}
ages[4]
```

To specify the range of the vector, it can be clearly indicate.
```{r}
ages[2:4]
```
We can have vectors of text, of boolean (TRUE/FALSE), or numbers.
```{r}
names<-c("Sally", "Jason", "Bob", "Susy") #Text
female<-c(TRUE, FALSE, FALSE, TRUE)
teacher<-c(Smith, Johnson, Johnson, Smith)
factor(teachers)
grades<-c(20, 15, 13, 19) #25 points possible
```
Vectors can be of several different types.
* **String.** These are the clear character vectors.  (Typically use quotes to add to these vectors.)
* **Numeric. **Numbers in a set.  Note there is not a different type  
* **Boolean. ** TRUE or FALSE values in a set. 
* **Factor.** A situation in which their is a select set of options.  Things such as states or zip codes.  These are typically things which are related to dummy variables, a topic we will discuss later. 

In each of the cases except *factor*, the default data type entered was correct.  In the case 

We can also apply functions to vectors to generate other variables and vectors.
```{r}
grades.sum<-sum(grades)
grades.sum
names.length<-nchar(names) 
names.length 
```

###R Challenge 1. 
In completing this challenge, you should do it in class. 
1. Swap the values of two variables, A and B.  
2. Create a function that returns that average, sum, and standard deviation of a vector.

##Intro to Python
When learning different languages, it is useful to map concepts.  In this case we will be going through the process of learning similar concepts in python that we have just learned in R.  The hope is that you will both be able to be fluent in more than one language and gain a better understanding of the underlying concepts.  

To access iPython, you just need to access another port of your localhost.  Localhost is your machine, and Vagrant has done an excellent job of mapping the ports on your machine (that is the 8001 below) to the appropriate port on the virtual machine.
[http://localhost:8001](http://localhost:8001) 
 
 The virtual machine is configured with [Jupyter](https://jupyter.org), a tool that evolved from the iPython notebook.  You see, a lot of people realized that the specific form of embedding HTML and code that makes up iPython notebooks, can also be useful for a number of other languages.  Jupyter enables use with Python, Julia, R, Haskell, or Ruby.  We will just be using Python in our in initial work.  











### Math and Variables in R
D


##Vectors and Matrixes with R
 




# Getting Started with Python
There are a tremendous wealth of tutorials out there that give you the basics of Python. Data science is quite different from application building through, necessitating not different understanding but different applications.

#IPython Notebook 
http://nbviewer.ipython.org/github/gumption/Python_for_Data_Science/blob/master/Python_for_Data_Science_all.ipynb

http://nbviewer.ipython.org/github/gumption/Python_for_Data_Science/blob/master/Python_for_Data_Science_all.ipynb

Natural Language Toolkit for Python
http://www.nltk.org/book/ 


### Photo Credits
Matrix
https://commons.wikimedia.org/wiki/File%3AMatrix.svg
By Lakeworks (Own work) [GFDL (http://www.gnu.org/copyleft/fdl.html) or CC BY-SA 4.0-3.0-2.5-2.0-1.0 (http://creativecommons.org/licenses/by-sa/4.0-3.0-2.5-2.0-1.0)], via Wikimedia Commons 


## Photo Credits
Header photo by Yale Rosen
Mucoepidermoid carcinoma, high grade Case 200
https://www.flickr.com/photos/pulmonary_pathology/6499879267 

