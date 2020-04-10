using System;
using System.Data.SqlClient;
using System.Data;
using System.Web.Script.Services;
using System.Web.Services;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContactBookAJAXJQUERYVersion
{
    public partial class Contact : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                bindDummy();
            }
        }

        [System.Web.Services.WebMethod(EnableSession = true), System.Web.Script.Services.ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string SaveContacts(string Name, string Mobile, string Address)
        {
            string Constr = System.Configuration.ConfigurationManager.ConnectionStrings["ContactBookConnString"].ConnectionString;
            SqlConnection con = new SqlConnection(Constr);
            string r = string.Empty;

            try
            {
                using (SqlCommand cmd = new SqlCommand("SaveContacts", con))
                {
                    con.Open();
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Name", Name);
                    cmd.Parameters.AddWithValue("@Mobile", Mobile);
                    cmd.Parameters.AddWithValue("@Address", Address);
                    cmd.Connection = con;
                    cmd.ExecuteNonQuery();
                  
                }
                return "1";
            }
            catch (SqlException exx)
            {
                string ab = string.Empty;
                if (exx.Number == 2627)
                {
                    r = "Something Went Wrong!!!";

                }
                return r;

            }
            catch (Exception ex)
            {
                return ex.Message;
            }

            finally
            {
                if (con.State == ConnectionState.Open)
                    con.Close();

            }
        }

        [System.Web.Services.WebMethod(EnableSession = true), System.Web.Script.Services.ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static string UpdateContacts(string Name, string Mobile, string Address)
        {
            string Constr = System.Configuration.ConfigurationManager.ConnectionStrings["ContactBookConnString"].ConnectionString;
            SqlConnection con = new SqlConnection(Constr);
            //string r = string.Empty;
            try
            {
                using (SqlCommand cmd = new SqlCommand("UpdateContacts", con))
                {
                    con.Open();
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Name", Name);
                    cmd.Parameters.AddWithValue("@Mobile", Mobile);
                    cmd.Parameters.AddWithValue("@Address", Address);

                    //SqlDataReader reader = cmd.ExecuteReader();

                    //if (reader.HasRows)
                    //{
                    //    //cmd.ExecuteNonQuery();
                    //    //return "1";
                    //}
                    //reader.Close();
                    //reader.Dispose();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

                return "1";
            }
            catch (Exception ex)
            {
               return ex.Message;
            }

        }

        [System.Web.Services.WebMethod(EnableSession = true), System.Web.Script.Services.ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static Contacts[] FillGridView()
        {
            string Constr = System.Configuration.ConfigurationManager.ConnectionStrings["ContactBookConnString"].ConnectionString;
            SqlConnection con = new SqlConnection(Constr);

            SqlDataAdapter sqldata = new SqlDataAdapter("ViewAllContacts", con);
            sqldata.SelectCommand.CommandType = System.Data.CommandType.StoredProcedure;

            //Derclaring a datatatable(invisible table)
            System.Data.DataTable dbtl = new System.Data.DataTable();
            List<Contacts> contactList = new List<Contacts>();
            //fill contacts or data into the datatable
            sqldata.Fill(dbtl);

            foreach (DataRow dr in dbtl.Rows)
            {
                Contacts c = new Contacts();
                c.Name = dr["Name"].ToString();
                c.Mobile= dr["Mobile"].ToString();
                c.Address= dr["Address"].ToString();
                contactList.Add(c);
            }
            con.Close();
            return contactList.ToArray();
           
            ////close connection
            //con.Close();

            ////linking Gridview with the datable
            //gvContact.DataSource = dbtl;

            ////Bindidng the data to the Gridview
            //gvContact.DataBind();

        }

        public void bindDummy()
        {
            DataTable dbtl = new DataTable();
            dbtl.Columns.Add("Name");
            dbtl.Columns.Add("Mobile");
            dbtl.Columns.Add("Address");


            //linking Gridview with the datable
            gvContact.DataSource = dbtl;

            //Bindidng the data to the Gridview
            gvContact.DataBind();

        }

    }
}