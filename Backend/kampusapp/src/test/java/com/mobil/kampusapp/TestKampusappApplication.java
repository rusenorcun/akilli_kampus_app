package com.mobil.kampusapp;

import org.springframework.boot.SpringApplication;

public class TestKampusappApplication {

	public static void main(String[] args) {
		SpringApplication.from(KampusappApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
