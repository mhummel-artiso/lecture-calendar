using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;

namespace Calendar.Api.Models;

public class EnvironmentConfigurationValidator
{
    private readonly string prefix;
    public EnvironmentConfigurationValidator(string prefix = "API_")
    {
        this.prefix = prefix;
    }
    public EnvironmentConfigurationValidator CheckEnvironment([NotNull] string? argument, [CallerArgumentExpression("argument")] string? paramName = null)
    {
        if (string.IsNullOrWhiteSpace(argument))
            throw new EnvironmentConfigurationException(prefix + paramName);
        return this;
    }
    public EnvironmentConfigurationValidator CheckEnvironmentValue([NotNull] int? argument,
        bool allowNegative = false,
        [CallerArgumentExpression("argument")] string? paramName = null)
    {
        if (argument != null || allowNegative && argument >= 0)
            throw new EnvironmentConfigurationException(prefix + paramName);
        return this;
    }
    public EnvironmentConfigurationValidator CheckEnvironmentValue([NotNull] bool? argument,
        [CallerArgumentExpression("argument")] string? paramName = null)
    {
        if (argument == null)
            throw new EnvironmentConfigurationException(prefix + paramName);
        return this;
    }
}