namespace Calendar.Api.Models;

public class EnvironmentConfigurationException : ArgumentException
{
    public EnvironmentConfigurationException(string argumentName) : base($"Missing environment configuration: {argumentName}")
    {

    }
}