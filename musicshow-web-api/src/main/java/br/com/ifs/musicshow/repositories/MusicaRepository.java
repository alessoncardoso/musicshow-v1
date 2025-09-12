package br.com.ifs.musicshow.repositories;

import br.com.ifs.musicshow.models.MusicaModel;
import br.com.ifs.musicshow.models.UsuarioModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MusicaRepository extends JpaRepository<MusicaModel, Integer> {

    List<MusicaModel> findByUsuario(UsuarioModel usuarioModel);

    List<MusicaModel> findByTituloAndUsuarioId(String titulo, Integer idUsuario);

}
