namespace Calendar.Api.Services.Interfaces;

public class KeyGenerator : IKeyGenerator
{
    const string CHARS = "abcdefghijklmnopqrstuvwxyz0123456789";
    private readonly static Random r = new Random();

    public string GenerateKey()
    {
        return new string(Enumerable.Repeat(CHARS, 24)
            .Select(s => s[r.Next(s.Length)]).ToArray());
    }
}