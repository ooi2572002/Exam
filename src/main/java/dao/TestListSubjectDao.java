package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import bean.TestListSubject;

public class TestListSubjectDao extends Dao {

    public List<TestListSubject> filter(int entYear, String classNum, String subjectCd) throws Exception {

        Map<String, TestListSubject> map = new LinkedHashMap<>();

        Connection connection = getConnection();
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            statement = connection.prepareStatement(
                "select s.ent_year, s.student_no, s.student_name, t.class_num, t.no, t.point" +
                " from test t" +
                " join student s on t.student_no = s.student_no" +
                " where s.ent_year = ?" +
                " and t.class_num = ?" +
                " and t.subject_cd = ?" +
                " order by t.class_num, s.student_no, t.no"
            );

            statement.setInt(1, entYear);
            statement.setString(2, classNum);
            statement.setString(3, subjectCd);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                String studentNo = resultSet.getString("student_no");

                if (!map.containsKey(studentNo)) {
                    TestListSubject bean = new TestListSubject();
                    bean.setEntYear(resultSet.getInt("ent_year"));
                    bean.setSutudentNo(studentNo);
                    bean.setStudentName(resultSet.getString("student_name"));
                    bean.setClassNum(resultSet.getString("class_num"));
                    bean.setPoints(new HashMap<>());
                    map.put(studentNo, bean);
                }

                int num   = resultSet.getInt("no");
                int point = resultSet.getInt("point");
                map.get(studentNo).getPoints().put(num, point);
            }

        } catch (Exception e) {
            throw e;
        } finally {
            if (statement != null) { try { statement.close(); } catch (SQLException sqle) { throw sqle; } }
            if (connection != null) { try { connection.close(); } catch (SQLException sqle) { throw sqle; } }
        }

        return new ArrayList<>(map.values());
    }
}
