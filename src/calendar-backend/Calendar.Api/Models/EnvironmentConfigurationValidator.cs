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
    public EnvironmentConfigurationValidator CheckEnvironmentBoolean([NotNull] bool? argument,
        [CallerArgumentExpression("argument")] string? paramName = null)
    {
        if (argument == null)
            throw new EnvironmentConfigurationException(prefix + paramName);
        return this;
    }

    public EnvironmentConfigurationValidator CheckEnvironmentNumber([NotNull] int? argument,
        bool allowNegative = false,
        [CallerArgumentExpression("argument")] string? paramName = null)
    {
        var ex = new EnvironmentConfigurationException(prefix + paramName);
        if (argument == null)
            throw ex;
        if (allowNegative || argument >= 0)
            return this;
        throw ex;
    }

    public EnvironmentConfigurationValidator CheckEnvironmentUri([NotNull] string? argument,
        bool isRelative = false,
        [CallerArgumentExpression("argument")] string? paramName = null)
    {
        if (string.IsNullOrWhiteSpace(argument))
            throw new EnvironmentConfigurationException(prefix + paramName);
        if (Uri.TryCreate(argument, isRelative ? UriKind.Relative : UriKind.Absolute, out var uri))
            return this;
        throw new EnvironmentConfigurationException(prefix + paramName, argument);

    }
}