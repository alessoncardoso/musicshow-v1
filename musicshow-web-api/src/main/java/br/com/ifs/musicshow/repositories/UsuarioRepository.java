package br.com.ifs.musicshow.repositories;

import br.com.ifs.musicshow.models.UsuarioModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<UsuarioModel, Integer> {

    boolean existsByEmail(String email);

    Optional<UsuarioModel> findByEmail(String email);

}
