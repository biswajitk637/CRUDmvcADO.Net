using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CRUDmvcADO.Net.DataAccess;
using CRUDmvcADO.Net.Models;

namespace CRUDmvcADO.Net.Controllers
{
    public class ProductController : Controller
    {
        ConnectionDB connectionDB = new ConnectionDB();
        // GET: Product
        public ActionResult Index()
        {
            var productList = connectionDB.GetAllProducts();
            if(productList.Count == 0)
            {
                TempData["InfoMessage"] = "No Data Available In the DataBase";
            }
            return View(productList);
        }

        // GET: Product/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Product/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Product/Create
        [HttpPost]
        public ActionResult Create(Product product)
        {
            try
            {
                // TODO: Add insert logic here
                bool IsInserted = false;
                if(ModelState.IsValid)
                {
                    IsInserted = connectionDB.InsertProduct(product);
                    if (IsInserted)
                    {
                        TempData["SucessMessage"] = "Product Details Save Successfully";
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "Product Is Availabe/Unable to Save Product Details into Database";
                    }
                }

                return RedirectToAction("Index");
            }
            catch(Exception ex)
            {
                TempData["ErrorMessage"] = ex.Message;
                return View();
            }
        }

        // GET: Product/Edit/5
        public ActionResult Edit(int id)
        {
            try
            {
                var product = connectionDB.GetAllProductID(id).FirstOrDefault();
                if (product == null)
                {
                    TempData["InfoMessage"] = "Product Not Available with ID" + id.ToString();
                    return RedirectToAction("Index");
                }
                return View(product);
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = ex.Message;
                return View();
            }
        }

        // POST: Product/Edit/5
        [HttpPost,ActionName("Edit")]
        public ActionResult UpdateProduct(Product product)
        {

            try
            {
                // TODO: Add Update logic here
                bool IsUpdated = false;
                if (ModelState.IsValid)
                {
                    IsUpdated = connectionDB.UpdateProduct(product);
                    if (IsUpdated)
                    {
                        TempData["SucessMessage"] = "Product Details Updated Successfully";
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "Product Is Availabe/Unable to Updated Product Details into Database";
                    }
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = ex.Message;
                return View();
            }
        }
        // GET: Product/Delete/5
        public ActionResult Delete(int id)
        {
            var product = connectionDB.GetAllProductID(id).FirstOrDefault();
            try
            {
                if (product == null)
                {
                    TempData["InfoMessage"] = "Product Not Available with ID" + id.ToString();
                    return RedirectToAction("Index");
                }
                return View(product);
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = ex.Message;
                return View();
            }

        }

        // POST: Product/Delete/5
        [HttpPost,ActionName("Delete")]
        public ActionResult DeleteConfirmation(int id)
        {
            try
            {
                string result = connectionDB.DeleteProduct(id);
                if(result.Contains("deleted"))
                {
                    TempData["SucessMessage"] = result;
                }
                else
                {
                    TempData["ErrorMessage"] = result;
                }
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {

                TempData["ErrorMessage"] = ex.Message;
                return View();
            }
        }
       
    }
}
