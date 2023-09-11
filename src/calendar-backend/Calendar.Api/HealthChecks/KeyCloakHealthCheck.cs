using Calendar.Api.Configurations;
using FS.Keycloak.RestApiClient.Client;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;

namespace Calendar.Api.HealthChecks;

public class KeyCloakHealthCheck : IHealthCheck
{
    public const string Name = "Keycloak";
    private readonly IHttpClientFactory httpClientFactory;
    private readonly ILogger<KeyCloakHealthCheck> logger;
    private readonly KeycloakRestEnvironmentConfiguration options;
    public KeyCloakHealthCheck(IHttpClientFactory httpClientFactory, IOptions<KeycloakRestEnvironmentConfiguration> options, ILogger<KeyCloakHealthCheck> logger)
    {
        this.httpClientFactory = httpClientFactory;
        this.logger = logger;
        this.options = options.Value;
    }
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            using var client = httpClientFactory.CreateClient();
            var response = await client.GetAsync(string.Concat(options.KEYCLOAK_BASE_URL.TrimEnd('/'), "/", "health"), cancellationToken);
            return response.IsSuccessStatusCode ? HealthCheckResult.Healthy() : HealthCheckResult.Degraded("Authentication server is not available");
        }
        catch (Exception e)
        {
            logger.LogError(e, "Keycloak health check failed");
            return HealthCheckResult.Unhealthy("Authentication server is not available", e);
        }
    }
}