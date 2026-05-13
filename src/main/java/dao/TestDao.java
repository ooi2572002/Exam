package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class TestDao extends Dao {

    public boolean save(String studentNo, String schoolCd, String subjectCd, int num, Integer point) throws Exception {

        Connection connection = getConnection();
        PreparedStatement checkStmt = null;
        PreparedStatement stmt = null;
        int count = 0;

        try {
            checkStmt = connection.prepareStatement(
                "SELECT COUNT(*) FROM test WHERE student_no = ? AND subject_cd = ? AND school_cd = ? AND no = ?"
            );
            checkStmt.setString(1, studentNo);
            checkStmt.setString(2, subjectCd);
            checkStmt.setString(3, schoolCd);
            checkStmt.setInt(4, num);

            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int exists = rs.getInt(1);
            rs.close();

            if (exists > 0) {
                stmt = connection.prepareStatement(
                    "UPDATE test SET point = ? WHERE student_no = ? AND subject_cd = ? AND school_cd = ? AND no = ?"
                );
                if (point == null) { stmt.setNull(1, java.sql.Types.INTEGER); } else { stmt.setInt(1, point); }
                stmt.setString(2, studentNo);
                stmt.setString(3, subjectCd);
                stmt.setString(4, schoolCd);
                stmt.setInt(5, num);
            } else {
                stmt = connection.prepareStatement(
                    "INSERT INTO test (student_no, subject_cd, school_cd, no, point, class_num)" +
                    " SELECT ?, ?, ?, ?, ?, class_num FROM student WHERE student_no = ?"
                );
                stmt.setString(1, studentNo);
                stmt.setString(2, subjectCd);
                stmt.setString(3, schoolCd);
                stmt.setInt(4, num);
                if (point == null) { stmt.setNull(5, java.sql.Types.INTEGER); } else { stmt.setInt(5, point); }
                stmt.setString(6, studentNo);
            }

            count = stmt.executeUpdate();

        } finally {
            if (checkStmt != null) { try { checkStmt.close(); } catch (SQLException e) { throw e; } }
            if (stmt != null) { try { stmt.close(); } catch (SQLException e) { throw e; } }
            if (connection != null) { try { connection.close(); } catch (SQLException e) { throw e; } }
        }

        return count > 0;
    }

    public List<Map<String, Object>> filterForRegist(String schoolCd, int entYear, String classNum, String subjectCd, int num) throws Exception {

        List<Map<String, Object>> list = new ArrayList<>();
        Connection connection = getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            stmt = connection.prepareStatement(
                "SELECT s.student_no, s.student_name, s.ent_year, s.class_num, t.point" +
                " FROM student s" +
                " LEFT JOIN test t ON s.student_no = t.student_no" +
                "   AND t.subject_cd = ? AND t.school_cd = ? AND t.no = ?" +
                " WHERE s.school_cd = ? AND s.ent_year = ? AND s.class_num = ? AND s.is_attend = true" +
                " ORDER BY s.class_num, s.student_no"
            );
            stmt.setString(1, subjectCd);
            stmt.setString(2, schoolCd);
            stmt.setInt(3, num);
            stmt.setString(4, schoolCd);
            stmt.setInt(5, entYear);
            stmt.setString(6, classNum);

            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("studentNo",   rs.getString("student_no"));
                row.put("studentName", rs.getString("student_name"));
                row.put("entYear",     rs.getInt("ent_year"));
                row.put("classNum",    rs.getString("class_num"));
                int point = rs.getInt("point");
                row.put("point", rs.wasNull() ? null : point);
                list.add(row);
            }

        } finally {
            if (rs != null) { try { rs.close(); } catch (SQLException e) { throw e; } }
            if (stmt != null) { try { stmt.close(); } catch (SQLException e) { throw e; } }
            if (connection != null) { try { connection.close(); } catch (SQLException e) { throw e; } }
        }

        return list;
    }

    /**
     * 学生×科目の成績を全件取得（削除確認用）
     */
    public List<Map<String, Object>> filterForDelete(String studentNo, String subjectCd, String schoolCd) throws Exception {

        List<Map<String, Object>> list = new ArrayList<>();
        Connection connection = getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            stmt = connection.prepareStatement(
                "SELECT no, point FROM test" +
                " WHERE student_no = ? AND subject_cd = ? AND school_cd = ?" +
                " ORDER BY no"
            );
            stmt.setString(1, studentNo);
            stmt.setString(2, subjectCd);
            stmt.setString(3, schoolCd);

            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("no",    rs.getString("no"));
                int point = rs.getInt("point");
                row.put("point", rs.wasNull() ? null : point);
                list.add(row);
            }

        } finally {
            if (rs != null) { try { rs.close(); } catch (SQLException e) { throw e; } }
            if (stmt != null) { try { stmt.close(); } catch (SQLException e) { throw e; } }
            if (connection != null) { try { connection.close(); } catch (SQLException e) { throw e; } }
        }

        return list;
    }

    /**
     * 学生×科目の成績を全件削除
     */
    public boolean deleteAll(String studentNo, String subjectCd, String schoolCd) throws Exception {

        Connection connection = getConnection();
        PreparedStatement stmt = null;
        int count = 0;

        try {
            stmt = connection.prepareStatement(
                "DELETE FROM test WHERE student_no = ? AND subject_cd = ? AND school_cd = ?"
            );
            stmt.setString(1, studentNo);
            stmt.setString(2, subjectCd);
            stmt.setString(3, schoolCd);
            count = stmt.executeUpdate();

        } finally {
            if (stmt != null) { try { stmt.close(); } catch (SQLException e) { throw e; } }
            if (connection != null) { try { connection.close(); } catch (SQLException e) { throw e; } }
        }

        return count > 0;
    }
}
