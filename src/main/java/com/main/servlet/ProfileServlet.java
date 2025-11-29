package com.main.servlet;

import com.main.dao.RHDAO;
import com.main.model.Employe;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private RHDAO rhdao;

    @Override
    public void init() throws ServletException {
        rhdao = new RHDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Employe employe = (Employe) session.getAttribute("currentUser");
        request.setAttribute("employe", employe);

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}