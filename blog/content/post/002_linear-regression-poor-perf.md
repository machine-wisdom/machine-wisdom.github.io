+++
categories = ["Predictive Modeling"]
date = "2016-09-15T05:53:17+06:00"
tags = ["Math", "Stats"]
title = "Getting linear regression to work"
description = "Linear regression is the first model explained in many machine learning books, but it is one of the trickiest to use. This post talks about two reasons why a linear regressor can be performing poorly, and how to fix them."
+++

Linear regression is the first model explained in many machine 
learning books, but it is one of the trickiest to use. This post talks about 
two reasons why a linear regressor can be performing poorly, and how to fix 
them. First, let me give my 2 cents about what a linear regressor is doing. 
It is going to be a very brief explanation, but I am sure you can find all 
the details you want on the Internet and in lots of high quality text books.

## Very brief explanation of linear regression

If linear regression is used, the programmer is making a claim
that the data can be explained by a straight line.
The regressor tries to find the straight line that passes as close
as possible to all the known data points. 
The formula of a straight line is `y = A.X + b`; 
where `y` is a single value representing what we care about predicting (called the target, response or dependent variable),
and `X` is a vector encapsulating all the signals we can measure on which the value of `y` depends (what the programmer believes to be important features). The regressor finds the values of the weight vector `A` and the intercept `b`, which _best fit the data_.

The lines _fits the data_ better if the loss function is smaller. The loss 
function used in linear regression is the Sum of Squared Errors (SSE), 
which is calculated by going through all the training data points, 
substituting the values of the features in `X` to get the estimated `y`,
finding the differences between the estimate and the observed value of `y` (according to the data),
squaring this difference (for various reasons that are beyond the scope of this post), 
and finally aggregating those squared differences by summing them. 
The regressor can only change the values of the weight vector `A` and the 
intercept `b` (which is basically the weight of a feature that always has the
value of 1). 
It goes into a loop and iterates on the values of the weights until it 
reaches the best weights it can get. 
In each iteration, the learning algorithm changes the weights by adding or subtracting a 
small value (called the learning rate) from some of them. The choice
of which weight to change at each iteration varies from one regression algorithm to another, 
but they all need the value of `y` to change gradually when changing the weights. This leads us to the situations I wanted to talk about.

## Feature encoding for better linear regression

In this section we will use a toy example problem where a linear regression
model is built to predict the sales in a given future date. The only data we 
have is the sales of the preceding 12 months, recorded as `(timestamp of sale, sale amount)`. 
The sale amount is the target variable, and it is recorded in some well defined unit already. 
The only other variable we have is the time of the sale, recorded as
a Linux epoch timestamp. 

A regressor tries to find weights such that the amount of sales can be predicted by multiplying those weights by the features. 
We are starting with a very accurate time of sale, down to the millisecond.
However, if we try to train a regressor on this data it will likely fail miserably.
The programmer needs to tell the regressor how to interpret this ever increasing value to extract meaningful features out of it (TODO: link to github project with sample code).
We humans understand that a point in time represents some time of day, 
in a day, in a month of a year. It can be a work day or a day off, 
and this varies by the country in which the sale happened. 
A programmer can extract all those features, but let's just extract the month and the year. Now the question is how to encode them?

### One hot encoding

A regressor treats all features as continuous ordinal variables, 
because it needs to be able to multiply the value of the features
by some weights and sum the results to get the value of the target variable. 
It is obvious that a categorical variable such as gender cannot
be encoded as 0, 1, 2 and 3 for example. Think about what happens if
we assign the gender correlated with the highest values of the reponse
to be encoded as the value 0. Also, gender is not ordinal and the values
0, 1, 2, 3 are ordinal. This is solved by something called one-hot encoding. 
Basically, create a feature for each possible category, and for each 
data point set the feature corresponding to the category of this point
to 1 and set the others to 0. You can read more about this in many sources.

What I want to cover is the effectiveness of one hot encoding in the case of
seemingly ordinal variables, such as the month. Well, I think you will get
it by just posing an example of how a regressor will fail without it.
Back to our toy example, imagine that the sales data come from a mountain 
resort so the values are high in the summer and winter months (hiking and skiing). 
Now, what will happen if we encode the month as a number from 1 to 12
and ask the regressor to find a weight for it? It will miserably fail,
because it will not be able to find a weight to use which gives a high
value for the response only when the month is 1, 2, 3, 6, 7 or 8. 
Using one hot encoding of the month the regressor can easily find a weight
for each month.

### Feature normalization

The second reason a linear regressor can fail to find suitable weights
is having high variability in the ranges of values of different features.
In our toy example, the one-hot encoded month takes values between 0 and 1, 
while the year takes values around 2000. What's wrong with that?
Well, for a poor regressor trying to find some weights by modifying them iteratively there are two problems. 
First, slight changes to the weight of the year feature causes 
changes to the value of the response variable that are much larger than 
the other variables. 
This can make the regressor diverge or at least fail to converge.
Second, even in case of convergence, the value of the weights will not 
be representative of the relative importance of the different features,
since some weights are multiplied by a value from 0 to 1 and other weights
are multiplied by a value around 2000. 
The value of the weight of a feature whose values are very large compared
to the response can also get too small that it can cause numerical instabilities.

The solution to this problem is normalizing all features, such that each 
feature has a value from 0 to 1, or from -1 to 1, or something like that. 
Features can be normalized in several ways, such as subtracting the minimum and dividing by the (maximum - minimum), or standardization. 
In the case of the year feature in our toy example, we can subtract the minimum year and divide by the age of the mountain resort. 
This gives us a feature whose weight will reflect the trend of sales.

## Conclusion

I hope I have given you some insight about how linear regression works
and how to massage the data to get it do a better job. This is by no means
a sufficient introduction to linear regression, and a proper text book
should be consulted. There are other pitfalls, such as including multiple
correlated features in the model, which are not as easy to explain but
they make a lot of sense (how to divide the weight capturing the effect
 of two correlated features between them?). Please [join the discussion 
 about this blog post on Gitter](https://gitter.im/machine-wisdom/blog-discussion_002_getting-linear-regression-to-work), and share with us
 any other pitfalls or insights. Needless to say, if you see a mistake
 in my blog post or if you really like it, please give me feedback about it.





