<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.beans.*" %>
<%@ page import="java.lang.reflect.*" %>
<pre>
<%

    Class.forName("org.postgresql.Driver");
    String url = "jdbc:postgresql://localhost/test", username = "test", password = "";
    try (Connection db = DriverManager.getConnection(url, username, password)) {

        out.println("Connection.getHoldability " + db.getHoldability());
        out.println("Connection.getTransactionIsolation " + db.getTransactionIsolation());
        out.println("Connection.getAutoCommit " + db.getAutoCommit());
        out.println("Connection.getCatalog " + db.getCatalog());
        out.println("Connection.getSchema " + db.getSchema());
        out.println("Connection.getClientInfo " + db.getClientInfo());
        // Postgres does not support getNetworkTimeout.
//    out.println("Connection.getNetworkTimeout " + db.getNetworkTimeout());

        // Postgres returns null for getTypeMap()!
        Map<String, Class<?>> types = db.getTypeMap();
        if (types != null) {
            out.println("Connection.getTypeMap:");
            for (Map.Entry<String, Class<?>> entry : types.entrySet()) {
                out.println("  " + entry.getKey() + " : " + entry.getValue());
            }
        }

        DatabaseMetaData meta = db.getMetaData();
        BeanInfo beanInfo = Introspector.getBeanInfo(DatabaseMetaData.class);
        for (PropertyDescriptor pd : beanInfo.getPropertyDescriptors()) {
            try {
                Method m = pd.getReadMethod();
                Object val = m.invoke(meta, new Object[]{});
                out.println("DatabaseMetaData." + pd.getName() + ": " + val);
            } catch (Exception e) {
                // Some getter throws NotSupportException, and we can ignore.
            }
        }

        ResultSet rs;
        rs = meta.getClientInfoProperties();
        while (rs.next()) {
            out.println("ClientInfoProperties." + rs.getObject(1));
        }
        rs = meta.getSchemas();
        while (rs.next()) {
            out.println("Schemas." + rs.getObject(1));
        }
        rs = meta.getCatalogs();
        while (rs.next()) {
            out.println("Catalogs." + rs.getObject(1));
        }
        rs = meta.getTableTypes();
        while (rs.next()) {
            out.println("TableTypes." + rs.getObject(1));
        }
        rs = meta.getTypeInfo();
        while (rs.next()) {
            out.println("TypeInfo." + rs.getObject(1));
        }
    }
%>
</pre>
