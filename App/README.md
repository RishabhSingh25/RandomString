# Code

Simple code in Python that runs a flask http server at port 8081. The response server return one string from selecting from the 4 values in map. 

# Dockerfile

I have created a multistage build to reduce the size of image. The first stage is builder stage that build a randomstring exec file and later passed to production stage that runs the exec file and exposes the port 8081.



