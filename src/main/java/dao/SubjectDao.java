package dao;
 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bean.School;
import bean.Subject;
 
public class SubjectDao extends Dao {
 
    // 科目1件取得（複合キー）

    public Subject get(School school, String subjectCd) throws Exception {
 
        Subject subject = null;

        Connection connection = getConnection();

        PreparedStatement statement = null;

        ResultSet rs = null;
 
        try {

            statement = connection.prepareStatement(

                "SELECT * FROM subject WHERE school_cd = ? AND subject_cd = ?"

            );

            statement.setString(1, school.getSchoolCd());

            statement.setString(2, subjectCd);
 
            rs = statement.executeQuery();
 
            if (rs.next()) {

                subject = new Subject();

                subject.setSubjectCd(rs.getString("subject_cd"));

                subject.setSubjectName(rs.getString("subject_name"));

                subject.setSchool(school); // School 型をセット

            }
 
        } finally {

            if (rs != null) rs.close();

            if (statement != null) statement.close();

            if (connection != null) connection.close();

        }
 
        return subject;

    }
 
    // ResultSet → List 変換

    private List<Subject> postFilter(ResultSet rs, School school) throws SQLException {
 
        List<Subject> list = new ArrayList<>();
 
        while (rs.next()) {

            Subject subject = new Subject();

            subject.setSubjectCd(rs.getString("subject_cd"));

            subject.setSubjectName(rs.getString("subject_name"));

            subject.setSchool(school); // School 型をセット

            list.add(subject);

        }
 
        return list;

    }
 
    // 科目一覧取得（School 型）

    public List<Subject> filter(School school) throws Exception {
 
        List<Subject> list = new ArrayList<>();

        Connection connection = getConnection();

        PreparedStatement statement = null;

        ResultSet rs = null;
 
        try {

            statement = connection.prepareStatement(

                "SELECT * FROM subject WHERE school_cd = ? ORDER BY subject_cd ASC"

            );

            statement.setString(1, school.getSchoolCd());
 
            rs = statement.executeQuery();

            list = postFilter(rs, school);
 
        } finally {

            if (rs != null) rs.close();

            if (statement != null) statement.close();

            if (connection != null) connection.close();

        }
 
        return list;

    }
 
    // 新規登録 or 更新

    public boolean save(Subject subject) throws Exception {
 
        Connection connection = getConnection();

        PreparedStatement statement = null;

        int count = 0;
 
        try {

            Subject old = get(subject.getSchool(), subject.getSubjectCd());
 
            if (old == null) {

                // INSERT

                statement = connection.prepareStatement(

                    "INSERT INTO subject (school_cd, subject_cd, subject_name) VALUES (?, ?, ?)"

                );

                statement.setString(1, subject.getSchool().getSchoolCd());

                statement.setString(2, subject.getSubjectCd());

                statement.setString(3, subject.getSubjectName());
 
            } else {

                // UPDATE

                statement = connection.prepareStatement(

                    "UPDATE subject SET subject_name = ? WHERE school_cd = ? AND subject_cd = ?"

                );

                statement.setString(1, subject.getSubjectName());

                statement.setString(2, subject.getSchool().getSchoolCd());

                statement.setString(3, subject.getSubjectCd());

            }
 
            count = statement.executeUpdate();
 
        } finally {

			// プリペアードステートメントを閉じる

			if (statement != null) {

				try {

					statement.close();

				} catch (SQLException sqle) {

					throw sqle;

				}

			}

			// コネクションを閉じる

			if (connection != null) {

				try {

					connection.close();

				} catch (SQLException sqle) {

					throw sqle;

				}

			}

        }
 
        return count > 0;

    }
 
    // 削除

    public boolean delete(School school, String subjectCd) throws Exception {
 
        Connection connection = getConnection();

        PreparedStatement statement = null;

        int count = 0;
 
        try {

            statement = connection.prepareStatement(

                "DELETE FROM subject WHERE school_cd = ? AND subject_cd = ?"

            );

            statement.setString(1, school.getSchoolCd());

            statement.setString(2, subjectCd);
 
            count = statement.executeUpdate();
 
        } finally {

            if (statement != null) statement.close();

            if (connection != null) connection.close();

        }
 
        return count > 0;

    }

}
 