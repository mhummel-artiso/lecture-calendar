using Calendar.Api.Models;
using System.Reflection.Metadata;

namespace Calendar.Api.Configurations;

public class DebugEnvironmentConfiguration : IEnvironmentConfiguration<DebugEnvironmentConfiguration>
{
    public bool DEBUG_TEST_ENDPOINT_ENABELD { get; set; } = false;
    public string DEBUG_TEST_ENDPOINT_POLICY { get; set; }
    public DebugEnvironmentConfiguration Validate()
    {
        var validator = new EnvironmentConfigurationValidator()
            .CheckEnvironmentValue(DEBUG_TEST_ENDPOINT_ENABELD);
        if (DEBUG_TEST_ENDPOINT_ENABELD)
        {
            validator.CheckEnvironment(DEBUG_TEST_ENDPOINT_POLICY);
            if (DEBUG_TEST_ENDPOINT_POLICY != AuthPolicies.EDITOR ||
                DEBUG_TEST_ENDPOINT_POLICY != AuthPolicies.VIEWER ||
                DEBUG_TEST_ENDPOINT_POLICY != AuthPolicies.EDITOR_VIEWER)
            {
                throw new EnvironmentConfigurationException(nameof(DEBUG_TEST_ENDPOINT_POLICY), DEBUG_TEST_ENDPOINT_POLICY);
            }
        }
        return this;
    }
}