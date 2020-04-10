using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ContactBookAJAXJQUERYVersion.Startup))]
namespace ContactBookAJAXJQUERYVersion
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
