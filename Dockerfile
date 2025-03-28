# Use the .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["SampleDotNetApp.csproj", "./"]
RUN dotnet restore

# Copy the rest of the application code
COPY . .

# Build the application
RUN dotnet build -c Release -o /app/build

# Publish the application
RUN dotnet publish -c Release -o /app/publish

# Use the .NET runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Expose ports
EXPOSE 80
EXPOSE 443
EXPOSE 5000
EXPOSE 8080

# Define the entry point for the container
ENTRYPOINT ["dotnet", "SampleDotNetApp.dll"]
