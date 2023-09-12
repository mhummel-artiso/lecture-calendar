namespace Calendar.Api.Configurations;

/// <summary>
/// Implement for all EnvironmentConfiguration this interface
/// <code>
///     var config = configuration.Get<[ClassName]>()?.Validate();
///     ArgumentNullException.ThrowIfNull(config);
/// </code>
/// </summary>
/// <typeparam name="T"></typeparam>
public interface IEnvironmentConfiguration<T>
{
    /// <summary>
    /// Validates the configuration
    /// </summary>
    /// <returns></returns>
    /// <exception cref="ArgumentException"></exception>
    public T Validate();
    T LogDebugValues(ILogger logger);
}