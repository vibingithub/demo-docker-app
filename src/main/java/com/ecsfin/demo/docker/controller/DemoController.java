package com.ecsfin.demo.docker.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dock")
public class DemoController {

	@GetMapping
	public ResponseEntity<String> getData(){
		return new ResponseEntity<String>("Success from Dock App", HttpStatus.OK);
	}
}
