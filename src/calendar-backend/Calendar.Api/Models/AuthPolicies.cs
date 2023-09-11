namespace Calendar.Api.Models;

public class AuthPolicies
{
    public const string EDITOR = nameof(EDITOR);
    public const string VIEWER = nameof(VIEWER);
    public const string EDITOR_VIEWER = nameof(EDITOR_VIEWER);
    // public const string ROLE_EDITOR_VIEWER = ROLE_EDITOR + "," + ROLE_VIEWER;
}