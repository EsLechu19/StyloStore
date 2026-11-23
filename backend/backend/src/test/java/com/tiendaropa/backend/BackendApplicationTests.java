package com.tiendaropa.backend;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class BackendApplicationTests extends AbstractMySqlTest {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Test
	void contextLoadsUsingTheIsolatedMySqlContainer() {
		String connectionUrl = jdbcTemplate.execute(
				(org.springframework.jdbc.core.ConnectionCallback<String>) connection ->
						connection.getMetaData().getURL());
		assertThat(connectionUrl).isEqualTo(MYSQL.getJdbcUrl());
	}

}
