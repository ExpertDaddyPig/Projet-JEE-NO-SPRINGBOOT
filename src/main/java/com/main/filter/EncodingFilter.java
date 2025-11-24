package com.main.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * Filtre pour forcer l'encodage UTF-8 sur toutes les requêtes et réponses
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {

    private String encoding = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null) {
            encoding = encodingParam;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // Forcer l'encodage UTF-8 pour la requête
        request.setCharacterEncoding(encoding);

        // Forcer l'encodage UTF-8 pour la réponse
        response.setCharacterEncoding(encoding);

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Nettoyage si nécessaire
    }
}