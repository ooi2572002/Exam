package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.TestListStudent;

public class TestListStudentDao extends Dao {

    public List<TestListStudent> filter(String studentNo) throws Exception {

        List<TestListStudent> list = new ArrayList<>();

        Connection connection = getConnection();
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            statement = connection.prepareStatement(
                "select sub.subject_name, t.subject_cd, t.no, t.point" +
                " from test t" +
                " join subject sub on t.subject_cd = sub.subject_cd and t.school_cd = sub.school_cd" +
                " where t.student_no = ?" +
                " and t.point is not null" +
                " order by t.subject_cd, t.no"
            );

            statement.setString(1, studentNo);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                TestListStudent bean = new TestListStudent();
                bean.setSubjectName(resultSet.getString("subject_name"));
                bean.setSubjectCd(resultSet.getString("subject_cd"));
                bean.setNum(resultSet.getInt("no"));
                bean.setPoint(resultSet.getInt("point"));
                list.add(bean);
            }

        } catch (Exception e) {
            throw e;
        } finally {
            if (statement != null) { try { statement.close(); } catch (SQLException sqle) { throw sqle; } }
            if (connection != null) { try { connection.close(); } catch (SQLException sqle) { throw sqle; } }
        }

        return list;
    }

    public String getStudentName(String studentNo) throws Exception {

        Connection connection = getConnection();
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        String studentName = null;

        try {
            statement = connection.prepareStatement(
                "select student_name from student where student_no = ?"
            );
            statement.setString(1, studentNo);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                studentName = resultSet.getString("student_name");
            }

        } catch (Exception e) {
            throw e;
        } finally {
            if (statement != null) { try { statement.close(); } catch (SQLException sqle) { throw sqle; } }
            if (connection != null) { try { connection.close(); } catch (SQLException sqle) { throw sqle; } }
        }

        return studentName;
    }
}
