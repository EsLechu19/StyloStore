# 👕 Tienda de Ropa Online

Sistema web de comercio electrónico desarrollado como proyecto académico de Ingeniería de Software, enfocado en la gestión integral de una tienda de ropa mediante una arquitectura Full Stack moderna.

El proyecto permite a los clientes explorar productos, administrar su carrito de compras y realizar pedidos, mientras que los administradores pueden gestionar productos, categorías, usuarios y pedidos desde un panel administrativo.

---

# 📌 Objetivos del Proyecto

* Implementar una aplicación web completa siguiendo una arquitectura cliente-servidor.
* Aplicar buenas prácticas de desarrollo Full Stack.
* Utilizar autenticación basada en JWT.
* Gestionar roles y permisos mediante Spring Security.
* Implementar persistencia de datos utilizando JPA/Hibernate y MySQL.
* Consumir APIs REST desde Angular.
* Integrar frontend y backend en una solución escalable.

---

# 🏗️ Arquitectura General

```text
┌─────────────────────┐
│      Angular        │
│      Frontend       │
└─────────┬───────────┘
          │ HTTP/JSON
          ▼
┌─────────────────────┐
│   Spring Boot API   │
│      Backend        │
└─────────┬───────────┘
          │ JPA
          ▼
┌─────────────────────┐
│       MySQL         │
│     Base de Datos   │
└─────────────────────┘
```

---

# 🚀 Tecnologías Utilizadas

## Frontend

* Angular 21
* TypeScript
* Bootstrap 5
* Bootstrap Icons
* RxJS

## Backend

* Java 21
* Spring Boot 4
* Spring Security
* Spring Data JPA
* Hibernate
* JWT (JSON Web Token)
* Lombok
* Maven

## Base de Datos

* MySQL

## Herramientas

* IntelliJ IDEA
* Visual Studio Code
* Postman
* Git
* GitHub

---

# 🔐 Seguridad

El sistema implementa un mecanismo de autenticación y autorización basado en JWT.

### Características

* Inicio de sesión seguro.
* Contraseñas cifradas mediante BCrypt.
* Tokens JWT para autenticación.
* Protección de endpoints mediante Spring Security.
* Control de acceso según roles.

---

# 👥 Roles del Sistema

## Administrador

Puede:

* Gestionar productos.
* Gestionar categorías.
* Gestionar usuarios.
* Visualizar pedidos.
* Administrar el catálogo de la tienda.

---

## Cliente

Puede:

* Registrarse.
* Iniciar sesión.
* Explorar productos.
* Ver detalles de productos.
* Agregar productos al carrito.
* Gestionar su perfil.
* Confirmar pedidos.
* Consultar historial de compras.

---

# 📂 Estructura del Proyecto

```text
Proyecto_Web_Integrado_7moCiclo
│
├── backend
│   │
│   ├── config
│   ├── controller
│   ├── dto
│   ├── entity
│   ├── repository
│   ├── service
│   ├── security
│   ├── exception
│   └── resources
│
├── frontend
│   │
│   ├── admin
│   ├── auth
│   ├── cliente
│   ├── pages
│   ├── services
│   ├── shared
│   └── models
│
└── database
```

---

# 📦 Principales Módulos

## Autenticación

Permite:

* Registro de usuarios.
* Inicio de sesión.
* Generación de JWT.
* Protección de recursos.

---

## Gestión de Productos

Permite:

* Crear productos.
* Editar productos.
* Eliminar productos.
* Consultar catálogo.
* Visualizar detalles.

---

## Gestión de Categorías

Permite:

* Crear categorías.
* Editar categorías.
* Eliminar categorías.
* Organizar productos.

---

## Carrito de Compras

Permite:

* Agregar productos.
* Actualizar cantidades.
* Eliminar productos.
* Visualizar subtotal.

---

## Pedidos

Permite:

* Confirmar compras.
* Registrar pedidos.
* Consultar historial.
* Gestionar estados.

---

## Usuarios

Permite:

* Registro.
* Administración de cuentas.
* Gestión de perfiles.
* Control de roles.

---

# 🗄️ Modelo de Datos

Entidades principales:

```text
Usuario
│
├── Carrito
│   └── DetalleCarrito
│
└── Pedido
    └── DetallePedido

Producto
│
├── Categoria
└── ProductoTalla
```

---

# ⚙️ Configuración del Backend

## Requisitos

* Java 21
* Maven
* MySQL

## Base de Datos

El backend usa Flyway para crear y validar el esquema al iniciar. Para una
instalación nueva, crear primero una base vacía:

```sql
CREATE DATABASE tienda_ropa_db;
```

Configurar la conexión mediante variables de entorno:

```text
DATABASE_URL=jdbc:mysql://localhost:3306/tienda_ropa_db?serverTimezone=UTC
DB_USERNAME=root
DB_PASSWORD=<database-password>
JWT_SECRET=<private-key-at-least-32-bytes>
```

Set `JWT_SECRET` to a private key of at least 32 bytes and keep it in a secret
manager or environment configuration; do not commit the key.

Al iniciar la aplicación, Flyway aplica las migraciones versionadas y Hibernate
valida el esquema; Hibernate no crea ni actualiza tablas. Las migraciones no
incluyen datos de demostración.

**Bases existentes:** no ejecutar migraciones sobre una base con datos sin una
revisión de compatibilidad del esquema y un respaldo verificado. El baseline
automático está desactivado por defecto; `FLYWAY_BASELINE_ON_MIGRATE` no debe
habilitarse hasta completar esa revisión y definir explícitamente el procedimiento.

---

## Ejecutar Backend

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

Servidor:

```text
http://localhost:8080
```

---

# ⚙️ Configuración del Frontend

## Requisitos

* Node.js
* Angular CLI

## Instalar dependencias

```bash
npm install
```

## Ejecutar aplicación

```bash
ng serve
```

Aplicación disponible en:

```text
http://localhost:4200
```

---

# 🧪 Pruebas

El backend puede ser probado mediante:

* Postman
* Thunder Client
* Insomnia

Endpoints principales:

```text
/api/auth/login

/api/usuarios

/api/productos

/api/categorias

/api/carrito

/api/pedidos
```

---

# 📚 Conceptos Aplicados

Durante el desarrollo se aplicaron conocimientos relacionados con:

* Programación Orientada a Objetos (POO)
* Arquitectura en Capas
* APIs REST
* JWT Authentication
* Spring Security
* JPA/Hibernate
* Angular SPA
* Gestión de Estados
* CRUD Completo
* Persistencia de Datos
* Control de Acceso por Roles
* Buenas Prácticas de Desarrollo

---

# 🎓 Contexto Académico

Proyecto desarrollado para el curso de **Desarrollo Web Integrado** de la carrera de **Ingeniería de Software**, con el objetivo de integrar tecnologías modernas de frontend, backend y bases de datos en una solución empresarial funcional.

---

# 👨‍💻 Autores

* Esaú Lechuga Monge
* Jose Lavado Yañez
* Josué Olivera Llantoy

Estudiantes de Ingeniería de Software

Intereses:

* Backend Development
* Full Stack Development
* Data Engineering
* Cloud Computing

---
