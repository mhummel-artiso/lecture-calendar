namespace Calendar.Api.Models;

public class EnvironmentConfigurationException : ArgumentException
{
    public EnvironmentConfigurationException(string argumentName) : 
        base($"Missing environment configuration: {argumentName}")
    {

    }
    public EnvironmentConfigurationException(string argumentName, string value) : 
        base($"The value {value} for {argumentName} is invalid")
    {
        
    }
}