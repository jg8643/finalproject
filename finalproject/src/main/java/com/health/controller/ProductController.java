package com.health.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.health.dto.CategoryDTO;
import com.health.dto.ProductDTO;
import com.health.service.CategoryService;
import com.health.service.ProductService;

@Controller
public class ProductController {
	@Autowired
	ProductService service;
	
	@Autowired
	@Qualifier("categoryservice")
	CategoryService cservice;
	
	@RequestMapping(value="/productlist")
	public ModelAndView productlist(Model model,
			@RequestParam(defaultValue = "1") String pagenum,
			@RequestParam(defaultValue = "9") String contentnum,
            @RequestParam(defaultValue = "category_num") String categorynum)throws Exception{
		ModelAndView mv= new ModelAndView();
		System.out.println(categorynum);
		service.execute(model, pagenum, contentnum, categorynum);
		List<CategoryDTO> clist = cservice.categorylist();
		mv.addObject("categorylist", clist);
		mv.setViewName("/productlist");
		return mv;
	}
	
	//상세정보 페이지
	@GetMapping(value="productdetail")
	public ModelAndView productdetail(@RequestParam(value="prod_num") int prod_num ) {
		ModelAndView mv = new ModelAndView();
		ProductDTO ProductDTO;
		try {
			ProductDTO =service.getproduct(prod_num);
			mv.addObject("product" , ProductDTO );
			mv.setViewName("productdetail");
		} catch (Exception e) {
		}
		return mv;
	}
	
	@ResponseBody
	  @RequestMapping(value="/selectList", method=RequestMethod.GET)
	  public List<ProductDTO> selectList(String search_text)throws Exception{
		  if(search_text == "") {
			  List<ProductDTO> list = new ArrayList<>(); 
			  return list;
		  }
		 return service.selectList(search_text);
	  }
	
}

