package com.salle.controller;

import com.salle.model.User;
import com.salle.service.WaitingListService;
import com.salle.util.URLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "WaitingListController", urlPatterns = {"/waitinglist", "/waitinglist/*"})
public class WaitingListController extends HttpServlet {

    private final WaitingListService waitingListService;

    public WaitingListController() {
        this.waitingListService = new WaitingListService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("waitingListEntries", waitingListService.getWaitingListForUser(user.getId()));
        request.getRequestDispatcher("/WEB-INF/views/waitinglist/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("cancel".equals(action)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                waitingListService.removeEntryFromWaitingList(id);
                response.sendRedirect(URLHelper.buildUrlWithMessage(request.getContextPath() + "/waitinglist", "Demande en attente annulée avec succès"));
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID invalide pour l\'annulation");
                doGet(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors de l\'annulation de la demande en attente: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action non supportée");
        }
    }
}
