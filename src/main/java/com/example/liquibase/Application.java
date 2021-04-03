package com.example.liquibase;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
	public static void main(String[] args) {
		// if oracle stupido -> help it
		String tz=System.getProperty("user.timezone");
		System.setProperty("user.timezone", tz==null||tz.trim().length()==0?"UTC":tz);

		SpringApplication.run(Application.class, args);
	}
}
