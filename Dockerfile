# # Set the base image to Python 3.9
# FROM python:3.11.0
# # Set environment variables
# ENV PYTHONUNBUFFERED 1
# ENV PYTHONDONTWRITEBYTECODE 1
# # Set the working directory to /app
# WORKDIR /app
# # Copy the requirements file into the container and install dependencies
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# # Copy the application code into the container
# COPY . .
# # Expose port 5000 for the Flask application
# EXPOSE 6616
# # Start the Flask development server
# CMD ["python", "manage.py", "runserver", "0.0.0.0:6616"]


# Builder stage
FROM node:18 as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn install --quiet
COPY . ./
RUN yarn build  # Make sure this step is included

# Production stage
FROM nginx:stable-alpine as production-stage
WORKDIR /usr/share/nginx/html
COPY --from=builder /usr/src/app/build .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]