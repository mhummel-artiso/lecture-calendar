using Microsoft.AspNetCore.DataProtection.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace Calendar.PostgreSQL.Db;

public class PersistKeyContext : DbContext, IDataProtectionKeyContext
{
    public PersistKeyContext(DbContextOptions options) : base(options)
    {

    }
    
    public DbSet<DataProtectionKey> DataProtectionKeys { get; set; }
}