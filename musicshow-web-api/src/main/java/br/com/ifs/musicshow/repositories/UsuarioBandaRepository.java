package br.com.ifs.musicshow.repositories;

import br.com.ifs.musicshow.models.UsuarioBandaModel;
import br.com.ifs.musicshow.models.UsuarioModel;
import br.com.ifs.musicshow.roles.UsuarioBandaRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UsuarioBandaRepository extends JpaRepository<UsuarioBandaModel, Integer> {

    List<UsuarioBandaModel> findByUsuarioAndPapelUser(UsuarioModel usuario, UsuarioBandaRole papelUser);

    boolean existsByBandaIdAndUsuarioIdAndPapelUser(Integer idBanda, Integer usuarioId, UsuarioBandaRole papelUser);

    boolean existsByBandaIdAndUsuarioId(Integer idBanda, Integer usuarioId);

    List<UsuarioBandaModel> findByBandaId(Integer idBanda);

}

