using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using CRUDmvcADO.Net.Models;

namespace CRUDmvcADO.Net.DataAccess
{
    public class ConnectionDB
    {
        string ConnctionString = ConfigurationManager.ConnectionStrings["cnn"].ToString();
        
        // Get All Products
        public List<Product> GetAllProducts()
        {
            List<Product> productList = new List<Product>();
            using(SqlConnection con=new SqlConnection(ConnctionString))
            {
                SqlCommand cmd = con.CreateCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "sp_GetAllProducts";
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Open();
                da.Fill(dt);
                con.Close();
                foreach (DataRow item in dt.Rows)
                {
                    productList.Add(new Product { 
                     ProductID=Convert.ToInt32( item["ProductID"]),
                      ProductName=item["ProductName"].ToString(),
                       Price=Convert.ToDecimal( item["Price"]),
                        Qty=Convert.ToInt32( item["Qty"]),
                         Remarks=item["Remarks"].ToString()
                    });
                }
            }
            return productList;
        }
        // Insert Products
        public bool InsertProduct(Product product)
        {
            using (SqlConnection con = new SqlConnection(ConnctionString))
            {
                int id = 0;
                SqlCommand cmd = con.CreateCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "sp_InsertProducts";
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                cmd.Parameters.AddWithValue("@ProductName", product.ProductName);
                cmd.Parameters.AddWithValue("@Price", product.Price);
                cmd.Parameters.AddWithValue("@Qty", product.Qty);
                cmd.Parameters.AddWithValue("@Remarks", product.Remarks);
                con.Open();
                id = cmd.ExecuteNonQuery();
                con.Close();
                if(id>0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        // Get All Products By ProductID
        public List<Product> GetAllProductID( int ProductID)
        {
            List<Product> productList = new List<Product>();
            using (SqlConnection con = new SqlConnection(ConnctionString))
            {
                SqlCommand cmd = con.CreateCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "sp_GetProductID";
                cmd.Parameters.AddWithValue("@ProductID", ProductID);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                con.Open();
                da.Fill(dt);
                con.Close();
                foreach (DataRow item in dt.Rows)
                {
                    productList.Add(new Product
                    {
                        ProductID = Convert.ToInt32(item["ProductID"]),
                        ProductName = item["ProductName"].ToString(),
                        Price = Convert.ToDecimal(item["Price"]),
                        Qty = Convert.ToInt32(item["Qty"]),
                        Remarks = item["Remarks"].ToString()
                    });
                }
            }
            return productList;
        }
        // Update Products
        public bool UpdateProduct(Product product)
        {
            using (SqlConnection con = new SqlConnection(ConnctionString))
            {
                int i = 0;
                SqlCommand cmd = new SqlCommand("sp_UpdateProducts",con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ProductID", product.ProductID);
                cmd.Parameters.AddWithValue("@ProductName", product.ProductName);
                cmd.Parameters.AddWithValue("@Price", product.Price);
                cmd.Parameters.AddWithValue("@Qty", product.Qty);
                cmd.Parameters.AddWithValue("@Remarks", product.Remarks);
                con.Open();
                i = cmd.ExecuteNonQuery();
                con.Close();

                if (i > 0)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        public string DeleteProduct(int productId)
        {
            string result = "";
            using(SqlConnection con =new SqlConnection(ConnctionString))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteProducts", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ProductID", productId);
                cmd.Parameters.Add("@OutpurMessage",SqlDbType.VarChar,50).Direction=ParameterDirection.Output;
                con.Open();
                cmd.ExecuteNonQuery();
                result = cmd.Parameters["@OutpurMessage"].Value.ToString();
                con.Close();
            }
            return result;
        }

    }
}