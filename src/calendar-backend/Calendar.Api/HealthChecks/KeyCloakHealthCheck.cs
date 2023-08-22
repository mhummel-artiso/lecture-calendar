using Calendar.Api.Configurations;
using FS.Keycloak.RestApiClient.Client;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;

namespace Calendar.Api.HealthChecks;

public class KeyCloakHealthCheck : IHealthCheck
{
    private readonly IHttpClientFactory httpClientFactory;
    private readonly KeycloakRestEnvironmentConfiguration options;
    public KeyCloakHealthCheck(IHttpClientFactory httpClientFactory, IOptions<KeycloakRestEnvironmentConfiguration> options)
    {
        this.httpClientFactory = httpClientFactory;
        this.options = options.Value;
    }
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        using var client = httpClientFactory.CreateClient();
        var response = await client.GetAsync(string.Concat(options.KEYCLOAK_BASE_URL, "health"));
        return response.IsSuccessStatusCode ? 
            HealthCheckResult.Healthy() :
            HealthCheckResult.Unhealthy("Authentication server is not available");

    }
}