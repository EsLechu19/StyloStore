package com.tiendaropa.backend;

import org.flywaydb.core.Flyway;
import org.junit.jupiter.api.Test;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
class FlywaySchemaIntegrationTest extends AbstractMySqlTest {

    @Autowired
    private Flyway flyway;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void migratesFreshMySqlSchemaAndHibernateValidatesIt() {
        assertThat(flyway.info().current().getVersion().getVersion()).isEqualTo("1");
        assertThat(flyway.validateWithResult().validationSuccessful).isTrue();
        assertThat(jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.tables " +
                        "WHERE table_schema = DATABASE() AND table_name <> 'flyway_schema_history'",
                Integer.class))
                .isEqualTo(9);
        assertThat(jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.referential_constraints " +
                        "WHERE constraint_schema = DATABASE()",
                Integer.class))
                .isEqualTo(10);
        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM usuarios", Integer.class)).isZero();
        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM productos", Integer.class)).isZero();
        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM categorias", Integer.class)).isZero();
    }

    @Test
    @Transactional
    void preventsDeletingRecordsReferencedByOrderHistory() {
        jdbcTemplate.update(
                "INSERT INTO usuarios (id_usuario, nombre, correo, password) " +
                        "VALUES (1, 'Test User', 'test@example.test', 'test-hash')");
        jdbcTemplate.update(
                "INSERT INTO categorias (id_categoria, nombre) VALUES (1, 'Test Category')");
        jdbcTemplate.update(
                "INSERT INTO productos (id_producto, nombre, precio, color, genero, id_categoria) " +
                        "VALUES (1, 'Test Product', 10.00, 'Blue', 'UNISEX', 1)");
        jdbcTemplate.update(
                "INSERT INTO pedidos (id_pedido, total, id_usuario) VALUES (1, 10.00, 1)");
        jdbcTemplate.update(
                "INSERT INTO detalle_pedido " +
                        "(id_detalle_pedido, cantidad, precio_unitario, subtotal, id_pedido, id_producto) " +
                        "VALUES (1, 1, 10.00, 10.00, 1, 1)");
        jdbcTemplate.update(
                "INSERT INTO historial_estado_pedido " +
                        "(id_historial, estado_anterior, estado_nuevo, id_pedido, id_usuario) " +
                        "VALUES (1, 'PENDIENTE', 'EN_PROCESO', 1, 1)");

        assertThatThrownBy(() -> jdbcTemplate.update("DELETE FROM usuarios WHERE id_usuario = 1"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbcTemplate.update("DELETE FROM productos WHERE id_producto = 1"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbcTemplate.update("DELETE FROM pedidos WHERE id_pedido = 1"))
                .isInstanceOf(DataIntegrityViolationException.class);

        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM usuarios", Integer.class)).isEqualTo(1);
        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM productos", Integer.class)).isEqualTo(1);
        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM pedidos", Integer.class)).isEqualTo(1);
        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM detalle_pedido", Integer.class)).isEqualTo(1);
        assertThat(jdbcTemplate.queryForObject("SELECT COUNT(*) FROM historial_estado_pedido", Integer.class))
                .isEqualTo(1);
    }
}
