using Microsoft.AspNetCore.DataProtection.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Calendar.PostgreSQL.Db;

public class PersistKeyContext : DbContext, IDataProtectionKeyContext
{
    public PersistKeyContext(DbContextOptions options) : base(options)
    {

    }
    public DbSet<DataProtectionKey> DataProtectionKeys { get; set; }
}