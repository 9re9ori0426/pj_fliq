package com.fliq.fliq.signup;

import com.fliq.fliq.MyBatisDB;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SignupDAO {

    // 기존 SignupC의 SignupDAO.addUser(request) 호출 방식을 유지한다.
    public static void addUser(HttpServletRequest request) {
        try (SqlSession sqlS = MyBatisDB.connect()) {
            String u_email = request.getParameter("u_email");
            String u_password = request.getParameter("u_password");
            String u_nickname = request.getParameter("u_nickname");

            // 애초에 xml에서 users_seq.NEXTVAL로 생성해서 u_id는 넘겨줄필요가없음
            SignupDTO users = new SignupDTO(0, u_email, u_password, u_nickname);

            if (sqlS.insert("fliqSql.insertUser", users) == 1) {
                sqlS.commit();
                System.out.println("add success");
                request.setAttribute("msg", "회원가입 성공");
            } else {
                request.setAttribute("msg", "회원가입에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "회원가입 처리 중 오류가 발생했습니다.");
        }
    }

    public static boolean loginCheck(HttpServletRequest request) {
        // 기본값은 true고 세션이없으면 객체를 새로만들게되는데 그러면 안되니까 false로 해둠
        HttpSession hs = request.getSession(false);
        // 세션에서 로그인한 회원 정보를 꺼내 user 변수에 담는 코드
        SignupDTO user = null;
        // 세션이 없으면 회원 정보도 없다.
        if (hs == null) {

            user = null;
        } else {
            // 세션에 저장된 회원 정보를 꺼낸다.
            user = (SignupDTO) hs.getAttribute("user");
        }

        return false;
    }

    public static void login(HttpServletRequest request) {
        // FLIQ에서는 이메일이 로그인 아이디다.
        String u_email = request.getParameter("u_email");
        String u_password = request.getParameter("u_password");

        if (u_email == null || u_email.isEmpty()
                || u_password == null || u_password.isEmpty()) {
            request.setAttribute("msg", "이메일과 비밀번호를 입력해주세요.");
            return;
        }

        try (SqlSession sqlS = MyBatisDB.connect()) {
            // ResultSet 대신 MyBatis가 SignupDTO에 조회 결과를 담는다.
            SignupDTO users = sqlS.selectOne("fliqSql.findUserByEmail", u_email);

            if (users == null) {
                request.setAttribute("msg", "등록된 이메일이 없습니다.");
            } else if (!u_password.equals(users.getU_password())) {
                request.setAttribute("msg", "비밀번호가 일치하지 않습니다.");
            } else {
                // 세션에는 비밀번호를 제외한 회원 정보만 보관한다.
                SignupDTO sessionUser = new SignupDTO(
                        // 비밀번호는 넘기지않는다 (보안이슈)
                        users.getU_id(), users.getU_email(), users.getU_password(), users.getU_nickname());

                HttpSession hs = request.getSession();
                request.changeSessionId();
                hs.setAttribute("user", sessionUser);
                hs.setMaxInactiveInterval(5 * 60);

                request.setAttribute("msg", "로그인 성공");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "로그인 처리 중 오류가 발생했습니다.");
        }
    }

    public static void logout(HttpServletRequest request) {
        HttpSession hs = request.getSession(false);
        if (hs != null) {
            // 로그인 정보만 제거한다. 다른 세션 속성은 유지한다.
            hs.removeAttribute("user");
        }
        request.setAttribute("msg", "로그아웃했습니다.");
    }

    public static void editUser(HttpServletRequest request) {
        HttpSession hs = request.getSession(false);
        SignupDTO user = hs == null ? null : (SignupDTO) hs.getAttribute("user");

        if (user == null) {
            request.setAttribute("msg", "로그인이 필요합니다.");
            return;
        }

        String u_password = request.getParameter("u_password");
        String u_nickname = request.getParameter("u_nickname");

        // 수정할 회원 번호는 input이 아니라 로그인한 세션에서 가져온다.
        SignupDTO users = new SignupDTO(
                user.getU_id(), user.getU_email(), u_password, u_nickname);

        try (SqlSession sqlS = MyBatisDB.connect()) {
            if (sqlS.update("fliqSql.editUser", users) == 1) {
                sqlS.commit();
                // DB 저장이 성공한 뒤 세션의 닉네임도 갱신한다.
                user.setU_nickname(u_nickname);
                System.out.println("edit success");
                request.setAttribute("msg", "회원정보를 수정했습니다.");
            } else {
                request.setAttribute("msg", "수정할 회원을 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "회원정보 수정 중 오류가 발생했습니다.");
        }
    }

    public static void deleteUser(HttpServletRequest request) {
        HttpSession hs = request.getSession(false);
        SignupDTO user = hs == null ? null : (SignupDTO) hs.getAttribute("user");

        if (user == null) {
            request.setAttribute("msg", "로그인이 필요합니다.");
            return;
        }

        String u_password = request.getParameter("u_password");
        if (u_password == null || u_password.isEmpty()) {
            request.setAttribute("msg", "탈퇴 확인용 비밀번호를 입력해주세요.");
            return;
        }

        SignupDTO users = new SignupDTO();
        users.setU_id(user.getU_id());
        users.setU_password(u_password);

        try (SqlSession sqlS = MyBatisDB.connect()) {
            // SQL에서 회원 번호와 현재 DB 비밀번호를 함께 확인한다.
            if (sqlS.delete("fliqSql.deleteUser", users) == 1) {
                sqlS.commit();
                logout(request);
                System.out.println("delete success");
                request.setAttribute("msg", "회원탈퇴를 완료했습니다.");
            } else {
                request.setAttribute("msg", "비밀번호가 다르거나 회원이 존재하지 않습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 상품·거래 등에서 참조하는 회원은 외래키 제약으로 삭제되지 않는다.
            request.setAttribute("msg", "회원탈퇴 처리 중 오류가 발생했습니다. 서버 콘솔을 확인해주세요.");
        }
    }

    // 기존 예제의 함수 이름을 유지한다. FLIQ에서 확인하는 대상은 이메일이다.
    // 0: 사용 중인 회원 없음, 1: 이미 사용 중, -1: 조회 오류 또는 입력 없음.
    public static int idcheck(HttpServletRequest request) {
        String u_email = request.getParameter("u_email");
        if (u_email == null || u_email.isEmpty()) {
            return -1;
        }

        try (SqlSession sqlS = MyBatisDB.connect()) {
            return sqlS.selectOne("fliqSql.countUserByEmail", u_email);
        } catch (Exception e) {
            e.printStackTrace();
            // DB 조회 실패를 '사용 가능(0)'으로 반환하지 않는다.
            return -1;
        }
    }
}