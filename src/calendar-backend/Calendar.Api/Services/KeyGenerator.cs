namespace Calendar.Api.Services.Interfaces;

public class KeyGenerator : IKeyGenerator
{
    const string CHARS = "abcdefghijklmnopqrstuvwxyz0123456789";
    private static readonly Random random = new Random();

    public string GenerateKey()
    {
        // not perfect
        return new string(Enumerable.Repeat(CHARS, 24)
            .Select(s => s[random.Next(s.Length)]).ToArray());
    }
}